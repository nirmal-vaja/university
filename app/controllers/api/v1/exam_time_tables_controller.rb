
class Api::V1::ExamTimeTablesController < ApiController
  before_action :set_time_table, only: [:update, :destroy]
  before_action :fetch_time_tables, only: [:index]

  def index
    page = params[:page] || 1
    items_per_page = params[:items_per_page]
    time_tables = @exam_time_tables.map do |time_table|
      @students = Student.where(branch_id: time_table.branch_id, semester_id: time_table.semester_id,fees_paid: true)
      time_table.attributes.merge({
        subject_name: time_table.subject_name,
        subject_code: time_table.subject_code
      })
    end
    @pagy, @students = pagy(@students, page: page, items: items_per_page)
    render json: {
      message: "Successfully fetched all the time tables",
      data: {
        time_tables: time_tables,
        students: @students,
        pagy: pagy_metadata(@pagy)
      }, status: :ok
    }
  end

  def create
    @exam_time_table = ExamTimeTable.new(time_table_params)
    @exam_time_table.semester = @exam_time_table.subject.semester
    @exam_time_table.branch = @exam_time_table.semester.branch
    @exam_time_table.course = @exam_time_table.branch.course
    authorize @exam_time_table

    begin
      ActiveRecord::Base.transaction do
        create_block_wise_reports
        raise ActiveRecord::Rollback unless @exam_time_table.save
        generate_and_store_blocks
        generate_block_extra_configs
        render json: {
          message: "Time table has been created",
          data: {
            time_table: @exam_time_table,
            block_details: @exam_time_table.time_table_block_wise_report
          }, status: :created
        }
      end
    rescue StandardError => e
      render json: {
        message: e.message,
        status: :unprocessable_entity
      }
    end
  end

  def update
    if @time_table.update(time_table_params)
      generate_block_extra_configs
      render json: {
        message: "Time table has been updated",
        data: {
          time_table: @time_table
        }, status: :ok
      }
    else
      render json: {
        message: @time_table.errors.full_messages.join(' '),
        status: :unprocessable_entity
      }
    end
  end

  def destroy
    if @time_table.destroy
      render json: {
        message: "Time Table has been destroyed",
        status: :ok
      }
    else
      render json: {
        message: @time_table.errors.full_messages.join(' '),
        status: :unprocessable_entity
      }
    end
  end

  def get_examination_dates
    @exam_time_tables = ExamTimeTable.where(time_table_params.except(:date)).order(date: :asc)

    if @exam_time_tables
      render json: {
        message: "Examination dates are as below",
        data: {
          dates: @exam_time_tables.pluck(:date).uniq,
        },status: :ok
      }
    else
      render json: {
        message: "No timetable found",
        status: :unprocessable_entity
      }
    end
  end

  def fetch_details
    subject = Subject.find_by_id(params[:id])
    @exam_time_table = ExamTimeTable.where(time_table_params)
    @exam_time_table = @exam_time_table.find_by(subject_id: params[:id])
    exam_time_table = @exam_time_table.attributes.merge(
      {
        subject_name: subject.name,
        subject_code: subject.code
      }
    ) if @exam_time_table.present?
    
    if exam_time_table
      render json: {
        message: "Details found",
        data: {
          time_table: exam_time_table
        }, status: :ok
      }
    else
      render json: {
        message: "No Details found",
        status: :unprocessable_entity
      }
    end
  end

  def fetch_subjects
    @time_tables = ExamTimeTable.where(time_table_params)
    @subjects = Subject.where(id: @time_tables.pluck(:subject_id)) if @time_tables.present?

    if @subjects
      render json: {
        message: "Subjects found",
        data: {
          subjects: @subjects
        }, status: :ok
      }
    else
      render json: {
        message: "Not found",
        status: :unprocessable_entity
      }
    end
  end

  def fetch_students
    page = params[:page] || 1
    items_per_page = params[:items_per_page]
    
    unassigned_students = Student.where(student_params, fees_paid: true)
                                  .where.not(id: StudentBlock.pluck(:student_id).uniq)

    if unassigned_students.present?
      @pagy, @students = pagy(unassigned_students, page: page, items: items_per_page)
      render json: {
        message: "Unassigned students found",
        data: {
          students: @students,
          pagy: pagy_metadata(@pagy)
        },
        status: :ok
      }
    else
      render json: {
        message: "You have already assigned students.",
        status: :not_found
      }
    end
  end

  def fetch_blocks
    @blocks = Block.includes(:students, :student_blocks)
                .where(block_params)
                .order(name: :asc)
                .select{ |block| block.students.count < block.capacity }
    if @blocks
      render json: {
        message: "Blocks found",
        data: {
          blocks: @blocks
        }, status: :ok
      }
    else
      render json: {
        message: "Blocks not found",
        status: :unprocessable_entity
      }
    end
  end

  private

  def set_time_table
    @time_table = ExamTimeTable.find_by_id(params[:id])
  end

  def generate_block_extra_configs
    total_number_of_blocks = 
      ExamTimeTable.where(
        date: @exam_time_table.date,
        time: @exam_time_table.time,
        name: @exam_time_table.name,
        academic_year: @exam_time_table.academic_year,
        course_id: @exam_time_table.course_id,
        time_table_type: @exam_time_table.time_table_type
      ).map{|x| x.time_table_block_wise_report.number_of_blocks}.compact.sum

    block_extra_config = BlockExtraConfig.find_or_create_by(
      examination_name: @exam_time_table.name,
      examination_type: @exam_time_table.time_table_type,
      academic_year: @exam_time_table.academic_year,
      course_id: @exam_time_table.course_id,
      date: @exam_time_table.date,
      time: @exam_time_table.time
    );

    block_extra_config.update(number_of_supervisions: total_number_of_blocks)
  end

  def create_block_wise_reports
    find_maximum_students_per_block
    find_no_students_appearing_for_this_exam
    blocks = (@number_of_students.to_f / @max_students_per_block)
    @exam_time_table.build_time_table_block_wise_report(
      examination_name: @exam_time_table.name,
      number_of_blocks: blocks.ceil(),
      academic_year: @exam_time_table.academic_year,
      no_of_students: @number_of_students,
      course_id: @exam_time_table.course_id,
      branch_id: @exam_time_table.branch_id,
      semester_id: @exam_time_table.semester_id,
      report_type: @exam_time_table.time_table_type
    )
  end

  def generate_and_store_blocks
    return unless @exam_time_table.time_table_block_wise_report.present?

    number_of_blocks = @exam_time_table.time_table_block_wise_report.number_of_blocks

    block_name = get_next_block_name

    number_of_blocks.times do
      @exam_time_table.blocks.create!(
        name: block_name,
        date: @exam_time_table.date,
        time: @exam_time_table.time,
        academic_year: @exam_time_table.academic_year,
        examination_name: @exam_time_table.name,
        course_id: @exam_time_table.course_id,
        branch_id: @exam_time_table.branch_id,
        capacity: @max_students_per_block,
        block_type: @exam_time_table.time_table_type,
        subject_id: @exam_time_table.subject_id,
        number_of_students: 0
      )

      block_name = get_next_block_name(block_name)
    end
  end

  def get_next_block_name(current_block = nil)
    max_block = Block.where(date: @exam_time_table.date).maximum(:name)

    if max_block.nil?
      return 'A' unless current_block
      return current_block.succ
    end

    return max_block.succ unless current_block
    current_block.succ.upto(max_block) do |name|
      return name unless Block.exists?(date: @exam_time_table.date, name: name)
    end
  end

  def find_maximum_students_per_block
    @max_students_per_block = ExaminationType.find_by_name(time_table_params[:time_table_type]).max_studentsper_block
  end

  def find_no_students_appearing_for_this_exam
    @number_of_students = Student.where(branch_id: time_table_params[:branch_id], semester_id: time_table_params[:semester_id], fees_paid: true).count
  end

  def fetch_time_tables
    @exam_time_tables = ExamTimeTable.where(time_table_params)
  end

  def time_table_params
    params.require(:time_table).permit(:name, :subject_id, :day, :date, :time, :academic_year, :course_id, :branch_id, :semester_id, :time_table_type).to_h
  end

  def block_params
    params.require(:block).permit(:examination_name, :academic_year, :subject_id, :date, :time, :course_id, :branch_id, :block_type ).to_h
  end

  def student_params
    params.require(:student).permit(:course_id, :branch_id, :semester_id).to_h
  end
end
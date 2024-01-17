class Api::V1::BlocksController < ApiController

  before_action :set_block, only: %i[assign_students]

  def index


    @blocks = Block.where(block_params)
  end


  def assign_students
    @students = Student.where(params[:student_ids])

    @students.each do |student|
      @block.student_blocks.create(
        student_id: student.id,
        examination_name: @block.examination_name,
        academic_year: @block.academic_year,
        course_id: @block.course_id,
        branch_id: @block.branch_id,
        semester_id: @block.semester_id
      )
    end

    render json: {
      data: {
        message: "Students are assigned to the block",
        status: :ok
      }
    }
  end

  private

  def set_block
    @block = Block.find_by_id(params[:id])
  end

  def block_params
    params.require(:block).permit(
      :academic_year,
      :examination_name,
      :course_id,
      :branch_id,
      :semester_id,
      :block_type
    )
  end

  def time_table_params
    params.require(:time_table).permit(
      :academic_year,
      :name,
      :time_table_type,
      :course_id,
      :branch_id,
      :semester_id,
      :subject_id,
      :date,
      :time
    )
  end
end
class ExamTimeTable < ApplicationRecord
  belongs_to :semester
  belongs_to :subject
  belongs_to :branch
  belongs_to :course

  has_one :time_table_block_wise_report, dependent: :destroy
  has_many :blocks, dependent: :destroy

  after_create :set_day

  after_commit :destroy_block_extra_config, on: [:destroy, :update]

  attr_accessor :subject_code, :subject_name

  validates_presence_of :name, :time, :date, :time_table_type
  validates :subject_id,  uniqueness: { scope: [:name, :academic_year] }

  enum day: {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }

  def subject_code
    subject.code
  end

  def subject_name
    subject.name
  end

  private

  def destroy_block_extra_config
    @exam_time_tables =
      ExamTimeTable.where(
        date: date,
        time: time,
        name: name,
        academic_year: academic_year,
        time_table_type: time_table_type,
        course_id: course_id
      )

    if @exam_time_tables.count.positive?
      block_extra_configs = 
        BlockExtraConfig.find_by(
          examination_name: name,
          examination_type: time_table_type,
          academic_year: academic_year,
          course_id: course_id,
          date: date,
          time: time
        )

      if block_extra_configs.present?
        number_of_supervisions = @exam_time_tables.map{|x| x.time_table_block_wise_report.number_of_blocks}.compact.sum
        block_extra_configs.update(number_of_supervisions: number_of_supervisions)
      end
    else
      BlockExtraConfig.where(
        examination_name: name,
        examination_type: time_table_type,
        academic_year: academic_year,
        course_id: course_id,
        date: date,
        time: time
      ).destroy_all
    end
  end

  def set_day
    self.day = date.wday
    self.save
  end
end

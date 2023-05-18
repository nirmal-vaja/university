class ExamTimeTablePolicy < ApplicationPolicy
  attr_reader :user, :exam_time_table

  def initialize(user, exam_time_table)
    @user = user
    @exam_time_table = exam_time_table
  end

  def create?
    @user.has_role? "Examination Controller"
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end

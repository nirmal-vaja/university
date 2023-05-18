class ExcelSheetPolicy < ApplicationPolicy
  attr_reader :user, :excel_sheet

  def initialize(user, excel_sheet)
    @user = user
    @excel_sheet = excel_sheet
  end

  def create?
    @user.has_role? "super_admin"
  end
end
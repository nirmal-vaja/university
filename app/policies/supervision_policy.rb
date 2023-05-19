class SupervisionPolicy < ApplicationPolicy
  attr_reader :user, :supervision

  def initialize(user, supervision)
    @user = user
    @supervision = supervision
  end

  def create?
    @user.has_role? "Examination Controller"
  end
end
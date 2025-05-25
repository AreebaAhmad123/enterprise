class MeetingPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    record.user == user || user.admin?
  end

  def create?
    user.client?
  end

  def destroy?
    record.user == user || user.admin?
  end

  def new?
    create?
  end

  def update?
    record.user == user || user.admin?
  end

  def edit?
    update?
  end
end

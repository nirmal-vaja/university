class BlockExtraConfig < ApplicationRecord
  belongs_to :course
  has_many :blocks

  def update_attributes_if_changes(new_attributes)
    assign_attributes(new_attributes)
    changes.each do |attribute, value|
      self[attribute] = value[0] if self[attribute] == value[1]
    end
    save!
  end
end

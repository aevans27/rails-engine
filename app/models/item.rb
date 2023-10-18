class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_items(name)
    self.where("name ILIKE ?", "%#{name}%").order(:name)
  end
end

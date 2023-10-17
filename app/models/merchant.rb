class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchant(name)
    self.where("name ILIKE ?", "%#{name}%").order(:name).first #only one?
  end
end

class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchants(name)
    self.where("name ILIKE ?", "%#{name}%").order(:name)
  end

  def self.find_merchant(name)
    self.where("name ILIKE ?", "%#{name}%").first #only one?
  end
end

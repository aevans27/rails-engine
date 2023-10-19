class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def self.find_items_by_name(name)
    self.where("name ILIKE ?", "%#{name}%").order(:name)
  end

  def self.find_items_by_min(min)
    self.where("unit_price > ?", min).order(:unit_price)
  end

  def self.find_items_by_max(max)
    self.where("unit_price < ?", max).order(:unit_price)
  end

  def self.find_item_by_name(name)
    self.where("name ILIKE ?", "%#{name}%").first #only one?
  end

  def self.find_item_by_min(min)
    self.where("unit_price > ?", min).order('name').first
  end

  def self.find_item_by_max(max)
    self.where("unit_price < ?", max).order('name').first
  end
end

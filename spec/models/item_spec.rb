require 'rails_helper'

RSpec.describe Item, type: :model do
  it "#find_items_by_name" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)

    found_items = Item.find_items_by_name("sod")
    expect(found_items.count).to eq(3)
  end

  it "#find_item_by_name" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)

    found_item = Item.find_item_by_name("pop")
    expect(found_item.name).to eq(soda1.name)
  end

  it "#find_item_by_min" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)

    found_item = Item.find_item_by_min("2.00")
    expect(found_item.name).to eq(pretzels.name)
  end
  it "#find_item_by_max" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)

    found_item = Item.find_item_by_max("3.00")
    expect(found_item.name).to eq(soda2.name)
  end
  it "#find_items_by_min" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)

    found_items = Item.find_items_by_min("3.00")
    expect(found_items.count).to eq(3)
  end
  it "#find_items_by_max" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)

    found_items = Item.find_items_by_max("3.00")
    expect(found_items.count).to eq(2)
  end
end

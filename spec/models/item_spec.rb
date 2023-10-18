require 'rails_helper'

RSpec.describe Item, type: :model do
  it "#find_items" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)

    found_items = Item.find_items("sod")
    expect(found_items.count).to eq(3)
  end
end

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it "#find_merchant" do
    merchant1 = create(:merchant, name:"Bubba")
    merchant2 = create(:merchant, name:"Ted")
    merchant3 = create(:merchant, name:"Steve")

    found_merchant = Merchant.find_merchant("Bub")
    expect(found_merchant.name).to eq(merchant1.name)
  end
end

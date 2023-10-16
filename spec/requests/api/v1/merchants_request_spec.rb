require 'rails_helper'

describe "Internal api Merchants" do
  it "checks all return from api/merchants" do
    create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_an(String)
    end
  end

  it "can get one merchant by its id" do
    merchant_id = create(:merchant).id
    create_list(:item, 3, merchant_id: merchant_id)
  
    get "/api/v1/merchants/#{merchant_id}/items"
  
    items = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful
  
    items.each do |item|
      expect(item).to have_key(:name)
      expect(item[:name]).to be_an(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_an(String)
require 'pry';binding.pry
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_an(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_an(Integer)
    end
  end
end
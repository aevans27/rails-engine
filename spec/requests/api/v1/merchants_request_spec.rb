require 'rails_helper'

describe "Internal api Merchants" do
  it "checks all return from api/merchants" do
    create_list(:merchant, 3)
    get '/api/v1/merchants'

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchants = response_body[:data]
    expect(merchants.count).to eq(3)
    expect(response).to be_successful

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it "can get merchant by id" do
    merchant = create(:merchant, name:"Bob")
    get "/api/v1/merchants/#{merchant.id}"

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchants = response_body[:data]
    
    expect(merchants.count).to eq(3)
    expect(response).to be_successful

    expect(merchants[:attributes]).to have_key(:name)
    expect(merchants[:attributes][:name]).to be_an(String)
  end

  it "get 404 from bad merchant id" do
    get "/api/v1/merchants/1"
    
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(merchant).to have_key(:errors)
    expect(merchant[:errors]).to eq("The merchant you are looking for does not exist")
  end

  it "can get merchant items" do
    merchant_id = create(:merchant).id
    create_list(:item, 3, merchant_id: merchant_id)
  
    get "/api/v1/merchants/#{merchant_id}/items"
  
    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]
  
    expect(response).to be_successful
  
    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_an(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price].to_f).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id].to_i).to be_an(Integer)
    end
  end

  it "find merchant by name" do
    merchant = create(:merchant, name:"Bubba")
    get "/api/v1/merchants/find?name=bub"
    found_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_merchant[:attributes][:name]).to eq(merchant.name)
  end
end
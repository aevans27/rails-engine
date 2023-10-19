require 'rails_helper'

describe "Find merchants by search" do
  it "find merchant by name" do
    merchant = create(:merchant, name:"Bubba")
    get "/api/v1/merchants/find?name=bub"
    found_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_merchant[:attributes][:name]).to eq(merchant.name)
  end

  it "error when no name given for single merchant" do
    merchant = create(:merchant, name:"Bubba")
    get "/api/v1/merchants/find?name="
    non_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_merchant).to have_key(:errors)
    expect(non_merchant[:errors]).to eq("Name is required for search")
  end

  it "error when name cannot be found" do
    merchant = create(:merchant, name:"Bubba")
    get "/api/v1/merchants/find?name=Steve"
    non_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(404)
    expect(non_merchant).to have_key(:errors)
    expect(non_merchant[:errors]).to eq("No merchant by that name")
  end

  it "can get merchants from search" do
    merchant = create(:merchant, name:"Bubba")
    merchant = create(:merchant, name:"Buddy")
    merchant = create(:merchant, name:"Steve")
    get "/api/v1/merchants/find_all?name=bu"

    found_merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_merchants.count).to eq(2)
    found_merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it "error when no name given for multiple merchants" do
    merchant = create(:merchant, name:"Bubba")
    get "/api/v1/merchants/find_all?name="
    non_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_merchant).to have_key(:errors)
    expect(non_merchant[:errors]).to eq("Name is required for search")
  end
end
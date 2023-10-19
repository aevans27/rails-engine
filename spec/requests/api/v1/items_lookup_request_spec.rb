require 'rails_helper'

describe "Find items by search" do
  it "find items by name" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)
    get "/api/v1/items/find_all?name=soda"
    found_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_items.count).to eq(3)
    
    found_items.each do |item|
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

  it "find item by name" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)
    get "/api/v1/items/find?name=soda"
    found_item = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(found_item[:attributes]).to have_key(:name)
    expect(found_item[:attributes][:name]).to be_an(String)

    expect(found_item[:attributes]).to have_key(:description)
    expect(found_item[:attributes][:description]).to be_an(String)
    expect(found_item[:attributes]).to have_key(:unit_price)
    expect(found_item[:attributes][:unit_price].to_f).to be_an(Float)

    expect(found_item[:attributes]).to have_key(:merchant_id)
    expect(found_item[:attributes][:merchant_id].to_i).to be_an(Integer)
  end

  it "error when name cannot be found" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)
    get "/api/v1/items/find?name=cheese"
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(404)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("No item by that name")
  end

  it "error when no name given for multiple items" do
    get "/api/v1/items/find_all?name="
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Name is required for search")
  end

  it "error when no name given for single item" do
    get "/api/v1/items/find?name="
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Name is required for search")
  end

  # Price error for item group section
  it "error when name and min price given" do
    get "/api/v1/items/find_all?name=soda&min_price=2.22"
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Cannot have name and price range")
  end

  it "error when name and max price given" do
    get "/api/v1/items/find_all?name=soda&max_price=2.22"
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Cannot have name and price range")
  end

  it "error when min_price is below 0" do
    get "/api/v1/items/find_all?min_price=-1"
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Price range too low")
  end

  it "error when max_price is below 0" do
    get "/api/v1/items/find_all?max_price=-1"
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Price range too low")
  end

  it "error when max and min price checked but either is below 0" do
    get "/api/v1/items/find_all?max_price=2&min_price=-1"
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Not reasonable price range")
  end

  it "error when name and min price given" do
    get "/api/v1/items/find?name=soda&min_price=2.22"
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Cannot have name and price range")
  end

  it "error when name and max price given" do
    get "/api/v1/items/find?name=soda&max_price=2.22"
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Cannot have name and price range")
  end

  it "error when min_price is below 0" do
    get "/api/v1/items/find?min_price=-1"
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Price range too low")
  end

  it "error when max_price is below 0" do
    get "/api/v1/items/find?max_price=-1"
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Price range too low")
  end

  it "error when max and min price checked but either is below 0" do
    get "/api/v1/items/find?max_price=2&min_price=-1"
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Not reasonable price range")
  end

  it "error when max and min price checked but max is less than min" do
    get "/api/v1/items/find?max_price=2&min_price=3"
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Not reasonable price range")
  end

  it "error when item by min price cannot be found" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)
    get "/api/v1/items/find?min_price=6"
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(404)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("No item within price range")
  end

  it "error when item by max price cannot be found" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)
    get "/api/v1/items/find?max_price=1"
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(404)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("No item within price range")
  end

   # Items search by price section
  it "get items by min price" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)

    get "/api/v1/items/find_all?min_price=3.00"
    expect(response.status).to eq(200)
    expect(response).to be_successful
    found_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_items.count).to eq(3)
    
    found_items.each do |item|
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

  it "get items by max price" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", unit_price: 1.11, merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", unit_price: 2.22, merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", unit_price: 3.33, merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", unit_price: 4.44, merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", unit_price: 5.55, merchant_id: merchant_id)

    get "/api/v1/items/find_all?max_price=3.00"
    expect(response.status).to eq(200)
    expect(response).to be_successful
    found_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_items.count).to eq(2)
    
    found_items.each do |item|
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

  it "find item by min_price" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)
    get "/api/v1/items/find?min_price=2"
    found_item = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(found_item[:attributes]).to have_key(:name)
    expect(found_item[:attributes][:name]).to be_an(String)

    expect(found_item[:attributes]).to have_key(:description)
    expect(found_item[:attributes][:description]).to be_an(String)
    expect(found_item[:attributes]).to have_key(:unit_price)
    expect(found_item[:attributes][:unit_price].to_f).to be_an(Float)

    expect(found_item[:attributes]).to have_key(:merchant_id)
    expect(found_item[:attributes][:merchant_id].to_i).to be_an(Integer)
  end

  it "find item by max_price" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)
    get "/api/v1/items/find?max_price=2"
    found_item = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(found_item[:attributes]).to have_key(:name)
    expect(found_item[:attributes][:name]).to be_an(String)

    expect(found_item[:attributes]).to have_key(:description)
    expect(found_item[:attributes][:description]).to be_an(String)
    expect(found_item[:attributes]).to have_key(:unit_price)
    expect(found_item[:attributes][:unit_price].to_f).to be_an(Float)

    expect(found_item[:attributes]).to have_key(:merchant_id)
    expect(found_item[:attributes][:merchant_id].to_i).to be_an(Integer)
  end

end
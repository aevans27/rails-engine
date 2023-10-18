require 'rails_helper'

describe "Internal api Items" do
  it "checks all return from api/items" do
    merchant_id = create(:merchant).id
    create_list(:item, 3, merchant_id: merchant_id)
    get '/api/v1/items'

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]
    expect(items.count).to eq(3)

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

  it "can get one item by its id" do
    merchant_id = create(:merchant).id
    item_list = create_list(:item, 3, merchant_id: merchant_id)
  
    get "/api/v1/items/#{item_list.last.id}"
  
    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
  
    expect(response).to be_successful
  
    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_an(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_an(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price].to_f).to be_an(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id].to_i).to be_an(Integer)
  end

  it "item doesn't exist" do
    get "/api/v1/items/1"

    item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(item).to have_key(:errors)
    expect(item[:errors]).to eq("The item you are looking for does not exist")
  end

  it "create a new item" do
    merchant_id = create(:merchant).id
    item_params = ({
                    name: 'Pie',
                    description: 'It is quite a pie',
                    unit_price: 20.01,
                    merchant_id: merchant_id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
                  # require 'pry';binding.pry
    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price.to_f).to eq(item_params[:unit_price])
    expect(created_item.merchant_id.to_i).to eq(item_params[:merchant_id])
  end

  it "can update an existing item" do
    merchant_id = create(:merchant).id
    id = create(:item, merchant_id: merchant_id).id
    previous_name = Item.last.name
    item_params = { name: "Bubba" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
    expect(response.status).to eq(200)
    expect(response).to be_successful
    # require 'pry';binding.pry
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Bubba")
  end

  it "bad merchant id when checking for item" do
    merchant_id = create(:merchant).id
    id = create(:item, merchant_id: merchant_id).id
    item_params = { name: "Bubba", merchant_id: 0 }
    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v1/items/1", headers: headers, params: JSON.generate({item: item_params})

    item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(item).to have_key(:errors)
    expect(item[:errors]).to eq("No item to update")
  end

  it "can destroy an item" do
    merchant_id = create(:merchant).id
    item = create(:item, merchant_id: merchant_id)
  
    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "error with bad item id" do
    merchant = create(:merchant)
    item_list = create_list(:item, 3, merchant_id: merchant.id)
    item = item_list.last
  
    headers = {"CONTENT_TYPE" => "application/json"}
    get "/api/v1/items/999999999/merchant"
  
    non_item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Item not found")
  end

  it "can find merchant from item" do
    merchant = create(:merchant)
    item_list = create_list(:item, 3, merchant_id: merchant.id)
    item = item_list.last
  
    headers = {"CONTENT_TYPE" => "application/json"}
    get "/api/v1/items/#{item_list.last.id}/merchant"
  
    item_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(response).to be_successful
    # require 'pry';binding.pry
    expect(item_merchant[:id].to_i).to eq(merchant.id)
    expect(item_merchant[:attributes]).to have_key(:name)
    expect(item_merchant[:attributes][:name]).to eq(merchant.name)
  end

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
    # expect(found_merchant[:attributes][:name]).to eq(merchant.name)
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

  it "error when no name given" do
    merchant_id = create(:merchant).id
    soda1 = create(:item, name: "Soda Pop", merchant_id: merchant_id)
    soda2 = create(:item, name: "Orange Soda", merchant_id: merchant_id)
    soda3 = create(:item, name: "Soda Cans", merchant_id: merchant_id)
    candy = create(:item, name: "Starburst", merchant_id: merchant_id)
    pretzels = create(:item, name: "Fosters", merchant_id: merchant_id)
    get "/api/v1/items/find_all?name="
    non_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(400)
    expect(non_item).to have_key(:errors)
    expect(non_item[:errors]).to eq("Name is required for search")
  end
end
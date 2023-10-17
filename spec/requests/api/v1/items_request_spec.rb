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

  it "create a new item" do
    merchant_id = create(:merchant).id
    item_params = ({
                    name: 'Cheese cake',
                    description: 'A cake made of cheese...and cake',
                    unit_price: 20.01,
                    merchant_id: merchant_id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
                  # require 'pry';binding.pry
    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price.to_f).to eq(item_params[:unit_price])
    expect(created_item.merchant_id.to_i).to eq(item_params[:merchant_id])
  end

  it "can update an existing book" do
    merchant_id = create(:merchant).id
    id = create(:item, merchant_id: merchant_id).id
    previous_name = Item.last.name
    item_params = { name: "Bubba" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
  
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Bubba")
  end

  it "can destroy an book" do
    merchant_id = create(:merchant).id
    item = create(:item, merchant_id: merchant_id)
  
    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can merchant from item" do
    merchant = create(:merchant)
    item_list = create_list(:item, 3, merchant_id: merchant.id)
    item = item_list.last
  
    headers = {"CONTENT_TYPE" => "application/json"}
    get "/api/v1/items/#{item_list.last.id}/merchant"
  
    item_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(response).to be_successful
  
    expect(item_merchant[:id].to_i).to eq(merchant.id)
    expect(item_merchant[:attributes]).to have_key(:name)
    expect(item_merchant[:attributes][:name]).to be_an(String)
  end
end
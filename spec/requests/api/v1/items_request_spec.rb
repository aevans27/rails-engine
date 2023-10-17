require 'rails_helper'

describe "Internal api Items" do
  it "checks all return from api/items" do
    merchant_id = create(:merchant).id
    create_list(:item, 3, merchant_id: merchant_id)
    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:name)
      expect(item[:name]).to be_an(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_an(String)
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price].to_f).to be_an(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id].to_i).to be_an(Integer)
    end
  end

  it "can get one item by its id" do
    merchant_id = create(:merchant).id
    item_list = create_list(:item, 3, merchant_id: merchant_id)
  
    get "/api/v1/items/#{item_list.last.id}"
  
    item = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful
  
      expect(item).to have_key(:name)
      expect(item[:name]).to be_an(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_an(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price].to_f).to be_an(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id].to_i).to be_an(Integer)
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
end
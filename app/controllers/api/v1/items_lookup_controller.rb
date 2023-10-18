class Api::V1::ItemsLookupController < ApplicationController
  def index
    items = Item.find_items(params[:name])
    if items == nil
      render json: {data:{errors: "No items by that name"}}, status: 404
    else
      render json: ItemSerializer.new(items)
    end
  end
end
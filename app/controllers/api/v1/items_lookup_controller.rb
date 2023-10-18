class Api::V1::ItemsLookupController < ApplicationController
  def index
    if params[:name].present?
      items = Item.find_items(params[:name])
      render json: ItemSerializer.new(items)
    else
      render json: {data:{errors: "Name is required for search"}}, status: 400
    end
  end
end
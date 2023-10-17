class Api::V1::ItemMerchantsController < ApplicationController
  def index
    if Item.exists?(params[:item_id])
    render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
    else
      render json: {errors: "Item not found"}, status: 404
    end
  end
end
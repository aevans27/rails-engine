class Api::V1::ItemsController < ApplicationController
  def index
    # require 'pry';binding.pry
    if params[:merchant_id].present?
    render json: Merchant.find(params[:merchant_id]).items
    else 
      render json: Item.all
    end
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    render json: Item.create(item_params)
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
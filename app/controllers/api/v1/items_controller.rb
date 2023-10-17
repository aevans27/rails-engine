class Api::V1::ItemsController < ApplicationController
  def index
    # require 'pry';binding.pry
    if params[:merchant_id].present?
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    else 
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render json: {errors: "Item not created"}, status: 404
    end
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
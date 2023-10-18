class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id].present?
      if Merchant.exists?(params[:merchant_id])
        render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
      else
        render json: {errors: "The merchant you are looking for does not exist"}, status: 404
      end
    else 
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {errors: "The item you are looking for does not exist"}, status: 404
    end
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
    if params[:item][:merchant_id].present?
      if Item.exists?(params[:id]) && Merchant.exists?(params[:item][:merchant_id])
        item = Item.update!(params[:id], item_params)
        render json: ItemSerializer.new(item)
      else
        render json: {errors: "No item to update"}, status: 404
      end
    else
      if Item.exists?(params[:id])
        item = Item.update!(params[:id], item_params)
        render json: ItemSerializer.new(item)
      else
        render json: {errors: "No item to update"}, status: 404
      end
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
class Api::V1::ItemsLookupController < ApplicationController
  def index
    # require 'pry';binding.pry
    if params[:name].present?
      if params[:min_price].present? || params[:max_price].present?
        render json: {data:{errors: "Cannot have name and price range"}}, status: 400
      else
        items = Item.find_items_by_name(params[:name])
        render json: ItemSerializer.new(items)
      end
    elsif params[:min_price].present? && params[:max_price].present?
      if params[:min_price] < 0 || params[:max_price] < 0
        render json: {errors: "Not reasonable price range"}, status: 400
      else

      end
    elsif params[:min_price].present? 
      if params[:min_price].to_f < 0
        render json: {errors: "Price range too low"}, status: 400
      else
        items = Item.find_items_by_min(params[:min_price])
        render json: ItemSerializer.new(items)
      end
    elsif params[:max_price].present? 
      if params[:max_price].to_f < 0
        render json: {errors: "Price range too low"}, status: 400
      else
        items = Item.find_items_by_max(params[:max_price])
        render json: ItemSerializer.new(items)
      end
    else
      render json: {data:{errors: "Name is required for search"}}, status: 400
    end
  end

  def show
    if params[:name].present?
      item = Item.find_item_by_name(params[:name])
      if params[:min_price].present? || params[:max_price].present?
        render json: {data:{errors: "Cannot have name and price range"}}, status: 400
      else
        if item == nil
          render json: {data:{errors: "No item by that name"}}, status: 404
        else
          render json: ItemSerializer.new(item)
        end
      end
    elsif params[:min_price].present? && params[:max_price].present?
      # require 'pry';binding.pry
      if params[:min_price].to_f < 0 || params[:max_price].to_f < 0
        render json: {data:{errors: "Not reasonable price range"}}, status: 400
      elsif params[:min_price].to_f > params[:max_price].to_f
        render json: {data:{errors: "Not reasonable price range"}}, status: 400
      else

      end
    elsif params[:min_price].present? 
      if params[:min_price].to_f < 0
        render json: {errors: "Price range too low"}, status: 400
      else
        item = Item.find_item_by_min(params[:min_price])
        if item == nil
          render json: {data:{errors: "No item by that name"}}, status: 404
        else
          render json: ItemSerializer.new(item)
        end
      end
    elsif params[:max_price].present? 
      if params[:max_price].to_f < 0
        render json: {errors: "Price range too low"}, status: 400
      else
        item = Item.find_item_by_max(params[:max_price])
        if item == nil
          render json: {data:{errors: "No item by that name"}}, status: 404
        else
          render json: ItemSerializer.new(item)
        end
      end
    else
      render json: {data:{errors: "Name is required for search"}}, status: 400
    end
  end
end
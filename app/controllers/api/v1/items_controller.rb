class Api::V1::ItemsController < ApplicationController
  def index
    # require 'pry';binding.pry
    render json: Merchant.find(params[:merchant_id]).items
  end
end
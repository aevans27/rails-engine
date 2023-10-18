class Api::V1::MerchantsLookupController < ApplicationController
  def index
    if params[:name].present?
      merchant = Merchant.find_merchant(params[:name])
      if merchant == nil
        render json: {data:{errors: "No merchant by that name"}}, status: 404
      else
        render json: MerchantSerializer.new(merchant)
      end
    else
      render json: {data:{errors: "Name is required for search"}}, status: 400
    end
  end
end
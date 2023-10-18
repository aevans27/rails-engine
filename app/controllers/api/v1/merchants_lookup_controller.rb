class Api::V1::MerchantsLookupController < ApplicationController
  def index
    merchant = Merchant.find_merchant(params[:name])
    if merchant == nil
      render json: {data:{errors: "No merchant by that name"}}, status: 404
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
class Payment < ApplicationRecord
	
	def self.prepare_webpay(params)
  	  {amount: params[:webpay_amount],
  	   id:  rand(1111111..9999999).to_s}
    end

end

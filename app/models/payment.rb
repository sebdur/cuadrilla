class Payment < ApplicationRecord
	
	def self.prepare_webpay(params)
  	  {info: params}
    end

end

class PaymentsController < ApplicationController
  require 'openssl'
  require 'base64'
  
  #before_action :prepare_webpay
  
  
  def create
		if !params[:payment][:webpay_amount].nil? && (webpay_payment = params[:payment][:webpay_amount].to_i) > 0  
			payment = Payment.prepare_webpay(payment_params) 
			result = WebpayInit.init_transaction(payment, request.base_url.to_s) 
			if(result['error_desc'] == 'TRX_OK')
				token = result['token']
				url   = result['url']   
				response = Net::HTTP.post_form(URI(url.to_s), token_ws: token.to_s)
				render html: response.body.html_safe
				return        
			else
				redirect_to webpay_error_path 
				return
			end
		else
			redirect_to :back, notice: 'Ha ocurrido un error procesando el pago.'
		end   
  end
  
  def new
  	 @payment = Payment.new
  end

  

  def webpay_success
  	 @payment = Payment.where(tbk_token: params[:token_ws]).lock(true).take
  end
  #Función que despliega una vista, indicando un error en la transacción
  def webpay_error
  end
  #Función que despliega información en el caso que el usuario haya cancelado la transacción
  def webpay_nullify
  end

  private
  
  def payment_params
  	params.require(:payment).permit(:webpay_amount)
  end

end

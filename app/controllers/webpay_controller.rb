class WebpayController < ApplicationController
  	skip_before_action :verify_authenticity_token
  	#Normal transaction  	
      def webpay_return_url
        result = WebpayInit.get_transaction_result(params[:token_ws], request.base_url.to_s)
        puts 'resultado obtenido: ' + result['buyorder'].to_s
        puts 'token de transbank: ' +  params[:token_ws]
        payment = Payment.find(result['buyorder'])
        payment.update(tbk_token: params[:token_ws])
        payment.update(state: 'pending') 
      if(result['error_desc'] == 'TRX_OK')
        state = result['error_desc'].to_s
        accountingdate 		= result['accountingdate'].to_s
        buyorder 					= result['buyorder'].to_s
        sharesnumber 					= result['sharesnumber'].to_s
        cardnumber 				= result['cardnumber'].to_s
        amount 						= result['amount'].to_s
        commercecode 			= result['commercecode'].to_s
        authorizationcode	= result['authorizationcode'].to_s
        paymenttypecode 	= result['paymenttypecode'].to_s
        responsecode 			= result['responsecode'].to_s
        transactiondate 	= result['transactiondate'].to_s
        urlredirection 		= result['urlredirection'].to_s
        vci 							= result['vci'].to_s

        if responsecode == '0' 
          webpay_data = [state, accountingdate, cardnumber, amount, authorizationcode, paymenttypecode, responsecode, transactiondate, urlredirection, vci, sharesnumber].to_s
          payment.update(state: 'complete')
          payment.update(webpay_data: webpay_data)
          payment.update(pay_date: Time.now)
          payment.update(verified: true)	
          response = Net::HTTP.post_form(URI(urlredirection.to_s), token_ws: params[:token_ws])
          render html: response.body.html_safe
        else
          payment.update(webpay_data: result['error_desc'])
          payment.update(description: "Pago con WebPay de: "+ current_user.client.full_name + " con errores")
          redirect_to webpay_error_path						
        end
        return					
      else
        payment.update(description: "Pago con WebPay de: "+ current_user.client.full_name + " con errores")
        payment.destroy
        redirect_to webpay_nullify_path
      end	  			
    end  	

    def webpay_final_url
      if(params[:TBK_ID_SESION] == nil)
        @payment =Payment.where(tbk_token: params[:token_ws]).take
        redirect_to webpay_success_path(token_ws: params[:token_ws])
      else
        redirect_to webpay_nullify_path
      end
    end
end
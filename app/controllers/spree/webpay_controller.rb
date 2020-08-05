module Spree
  class WebpayController < StoreController
    skip_before_action :verify_authenticity_token
    before_action :load_data

    def webpay_return_url
      trx_result = ''
      if @result_trx['error_desc'] = 'TRX_OK'
        @order = Spree::Order.find_by_number(@result_trx['buyorder'])
        @payment = @order.payments.last
        @payment.update(webpay_trx_id: params['token_ws'])
        @payment.update(state: 'pending')

        state = @result_trx['error_desc'].to_s
        accountingdate    = @result_trx['accountingdate'].to_s
        buyorder          = @result_trx['buyorder'].to_s
        sharesnumber      = @result_trx['sharesnumber'].to_s
        cardnumber        = @result_trx['cardnumber'].to_s
        amount            = @result_trx['amount'].to_s
        commercecode      = @result_trx['commercecode'].to_s
        authorizationcode = @result_trx['authorizationcode'].to_s
        paymenttypecode   = @result_trx['paymenttypecode'].to_s
        responsecode      = @result_trx['responsecode'].to_s
        transactiondate   = @result_trx['transactiondate'].to_s
        urlredirection    = @result_trx['urlredirection'].to_s
        vci               = @result_trx['vci'].to_s

        if responsecode == '0'
          tracking = ApiShipping.new(@order)
          order_shipping = @order.shipments.ids.join.to_i

          if ApiShipping.geo_reference(tracking.shipping) != false
            tracking_code = ApiShipping.envio(tracking.shipping)
            Spree::Shipment.find_by(id: order_shipping).update(tracking: tracking_code)
            Spree::Shipment.find_by(id: order_shipping).update(state: "shipped")
            Spree::Order.find_by(id: @order.id).update(shipment_state: "shipped")
          else
            Spree::Shipment.find_by(id: order_shipping).update(state: "pending")
            Spree::Order.find_by(id: @order.id).update(shipment_state: "pending")
          end

          webpay_data = [state, accountingdate, cardnumber, amount, authorizationcode, paymenttypecode, responsecode, transactiondate, urlredirection, vci, sharesnumber].to_s
          @payment.update(state: 'complete')
          @payment.update(webpay_params: webpay_data)
          @order.update(completed_at: Time.now)
          #@payment.update(pay_date: Time.now)
          #@payment.update(verified: true)
          response = Net::HTTP.post_form(URI(urlredirection.to_s), token_ws: params[:token_ws])
          #if con el flujo agregado con chilexpress
            #order.udpate(shippment_state: 'complete')

          flash[:order_completed] = true
          render 'spree/orders/show'

        else
          @payment.update(webpay_params: @result_trx['error_desc'])
          @payment.update(cvv_response_message: "Pago con webpay de: " + @order.email + " con errores")
          redirect_to webpay_error_path
        end
        return
      else
        @payment = order.payments.last
        @payment.update(cvv_response_message: "Pago con webpay de: " + order.email + " nulo")
        @payment.destroy
        redirect_to webpay_nullify_path
      end
    end

    def webpay_final_url
      debugger
    end

    private
    def load_data
      provider = PaymentMethod.find_by_type('Spree::Gateway::SpreeTbk').provider.new
      @result_trx = provider.transaction_result(params[:token_ws])
    end

    def completion_route
      spree.order_path(@order)
    end
  end
end

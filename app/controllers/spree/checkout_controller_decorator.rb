module Spree
	module CheckoutControllerDecorator
		def update
			if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
        @order.temporary_address = !params[:save_user_address]
        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to(checkout_state_path(@order.state)) && return
        end

        if @order.completed?
          @current_order = nil
          flash['order_completed'] = true
          redirect_to completion_route
        else
          redirect_to checkout_state_path(@order.state)
        end

				if @order.state == "payment"

					commune = @order.bill_address.address2.upcase
					commune_code = QuoteCost.find_by(name: commune).code
					#hace split de address1 y elimina ultimo espacio del array
					name_address = @order.bill_address.address1.split(" "); name_address.pop
					name_address = name_address.join(" ")
					num_address = @order.bill_address.address1.split(" ").last.to_i
					observation = @order.bill_address.zipcode
					contact_name = @order.bill_address.firstname + " " + @order.bill_address.lastname
					contact_number = @order.bill_address.phone
					contact_email = @order.email
					@shipping_request = ApiShipping.new.envio(commune, commune_code, name_address, num_address, observation, contact_name, contact_number, contact_email)
					byebug
				end
      else
        render :edit
      end
		end
	end
end

::Spree::CheckoutController.prepend ::Spree::CheckoutControllerDecorator if ::Spree::CheckoutController.included_modules.exclude?(::Spree::CheckoutControllerDecorator)

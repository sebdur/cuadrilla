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
			else
				render :edit
			end
		end
	end
end
::Spree::CheckoutController.prepend ::Spree::CheckoutControllerDecorator if ::Spree::CheckoutController.included_modules.exclude?(::Spree::CheckoutControllerDecorator)
		

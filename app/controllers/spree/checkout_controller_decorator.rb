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

				#este if es  momentaneo mientras no exista webpay, cuando exista se debeara cambiar en @oreder.completed?
				if @order.state == "payment"
<<<<<<< HEAD

					#atributo spree es address2 -> comuna de la ciudad y/o region
=======
>>>>>>> 65b52dafc3ac9b680bd2ff54161ab47c14470a0e
					commune = @order.bill_address.address2.upcase
					commune_code = QuoteCost.find_by(name: commune).code
					#hace split de address1 y elimina ultimo espacio del array para manejar direccion sin numeracion
					name_address = @order.bill_address.address1.split(" "); name_address.pop
					name_address = name_address.join(" ")
					#hace split solo para dejar numeracion de la direccion
					num_address = @order.bill_address.address1.split(" ").last.to_i
					#spree maneja el zipcode se modifica para el manejo que se trate como atributo observacion del envio(departemento x y otro tipo de observaciones referente al envio)
					observation = @order.bill_address.zipcode
					#se concatena nombre y apellido
					contact_name = @order.bill_address.firstname + " " + @order.bill_address.lastname
					contact_number = @order.bill_address.phone
					contact_email = @order.email
					#codigo para request de envio solicitado en el objeto package.serviceDeliveryCode
					service_delivery_code = QuoteCost.find_by(name: commune).service_delivery_code
					@shipping_request = ApiShipping.new.envio(commune, commune_code, name_address, num_address, observation, contact_name, contact_number, contact_email,service_delivery_code)
				end
			else
				render :edit
			end
		end
	end
end

::Spree::CheckoutController.prepend ::Spree::CheckoutControllerDecorator if ::Spree::CheckoutController.included_modules.exclude?(::Spree::CheckoutControllerDecorator)

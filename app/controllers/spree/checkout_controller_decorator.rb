module Spree
	module CheckoutControllerDecorator
		#def update
			
		#end
	end
end
::Spree::CheckoutController.prepend ::Spree::CheckoutControllerDecorator if ::Spree::CheckoutController.included_modules.exclude?(::Spree::CheckoutControllerDecorator)
		

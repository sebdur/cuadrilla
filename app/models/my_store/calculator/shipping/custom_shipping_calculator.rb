class MyStore::Calculator::Shipping::CustomShippingCalculator < Spree::ShippingCalculator
  def self.description
    "Custom Shipping Calculator Chilexpress"
  end

  def compute_package(package)
    #customizacion de calculadora toma la comuna para
    commune = package.order.bill_address.address2.upcase
    if QuoteCost.exists?(name: commune)
      quote_amount = QuoteCost.find_by(name: commune).cost
    else
      # flash[:warning] = "Hubo un problema enviando tu mensaje. Por favor intenta otra vez"
      # flash[:error] = "lala"
    end
  end

  def avaible?(order)
    order.currency == 'CLP'
  end
end

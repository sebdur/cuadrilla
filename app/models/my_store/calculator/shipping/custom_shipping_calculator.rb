class MyStore::Calculator::Shipping::CustomShippingCalculator < Spree::ShippingCalculator
  def self.description
    "Custom Shipping Calculator Chilexpress"
  end

  def compute_package(package)
    commune = package.order.bill_address.address2
    quote_amount = QuoteCost.find_by(name: commune).cost
  end

  def avaible?(order)
    order.currency == 'CLP'
  end
end

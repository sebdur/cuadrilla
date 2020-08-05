require "uri"
require "net/http"
require "json"
class ApiShipping
  API_KEY_GEO_REFERENCE = '8bdf751a989c40e68047dd8bbdfbe4b3'
  API_KEY_ENVIO = '6da83444ca8a4d7a993161e9b39effb8'

  attr_reader :shipping

  def initialize(order)
    @shipping = {}
    commune = order.bill_address.address2.upcase
    commune =  ActiveSupport::Inflector.transliterate(commune).to_s
    commune.include?("Ñ") ? @shipping[:commune] = commune.gsub(/[Ñ]/,"N") : @shipping[:commune] = commune
    @shipping[:commune_code] = QuoteCost.find_by(name: commune).code
    #hace split de address1 y elimina ultimo espacio del array para manejar direccion sin numeracion
    name_address = order.bill_address.address1.split(" "); name_address.pop
    @shipping[:name_address] = name_address.join(" ")
    #hace split solo para dejar numeracion de la direccion
    @shipping[:num_address] = order.bill_address.address1.split(" ").last.to_i
    #spree maneja el zipcode se modifica para el manejo que se trate como atributo observacion del envio(departemento x y otro tipo de observaciones referente al envio) => hacer cambiar campo a tipo text
    @shipping[:observation] = order.bill_address.zipcode
    #se concatena nombre y apellido
    @shipping[:contact_name] = order.bill_address.firstname + " " + order.bill_address.lastname
    @shipping[:contact_number] = order.bill_address.phone
    @shipping[:contact_email] = order.email
    #codigo para request de envio solicitado en el objeto package.serviceDeliveryCode
    @shipping[:service_delivery_code] = QuoteCost.find_by(name: commune).service_delivery_code
    return @shipping
  end


  #return de este es address id para destino.
    def self.geo_reference(shipping)
      url = URI("https://testservices.wschilexpress.com/georeference/api/v1.0/addresses/georeference?Ocp-Apim-Subscription-Key=#{API_KEY_GEO_REFERENCE}")
      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request.body = {countyName: shipping[:commune],
                      streetName: shipping[:name_address],
                      number: shipping[:num_address]
                     }.to_json

      response = https.request(request)
      address_id = JSON[response.read_body]

      #return response con el address.id
      if address_id['statusCode'] == 0
        return address_id['data']['addressId']
      elsif address_id['statusCode'] == -4
        return false
      else
        return false
      end
    end

  #return del numero orden de transporte, (data.detail.transportOrderNumber)
  def self.envio(shipping)
    url = URI("https://testservices.wschilexpress.com/transport-orders/api/v1.0/transport-orders")

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Ocp-Apim-Subscription-Key"] = "#{API_KEY_ENVIO}"
    request['Cache-Control'] = 'no-cache'
    request["Content-Type"] = "application/json"
    request.body = {  header: {
                                certificateNumber: 0,
                                customerCardNumber: "18578680",
                                countyOfOriginCoverageCode: "PROV",
                                labelType: 2,
                                marketplaceRut: "96756430",
                                sellerRut: "DEFAULT"
                              },
                            details: [
                            {
                                addresses: [
                                  {
                                    addressId: geo_reference(shipping),
                                    countyCoverageCode: shipping[:commune_code],
                                    streetName: shipping[:name_address],
                                    streetNumber: shipping[:num_address],
                                    supplement: "DEFAULT",
                                    addressType: "DEST",
                                    deliveryOnCommercialOffice: false,
                                    commercialOfficeId: "706",
                                    observation: shipping[:observation]
                                  },
                                  {
                                    addressId: 18025074,
                                    countyCoverageCode: "STGO",
                                    streetName: "AVENIDA VICUNA MACKENNA",
                                    streetNumber: 819,
                                    supplement: "DEFAULT",
                                    addressType: "DEV",
                                    deliveryOnCommercialOffice: false,
                                    observation: "DEFAULT"
                                  }
                                ],
                                contacts: [
                                  {
                                    name: "Eric Olivares",
                                    phoneNumber: "+56993813039",
                                    mail: "contacto@cuadrilla.cl",
                                    contactType: "R"
                                  },
                                  {
                                    name: shipping[:contact_name],
                                    phoneNumber: shipping[:contact_number],
                                    mail: shipping[:contact_email],
                                    contactType: "D"
                                  }
                                ],
                                packages: [
                                  {
                                    weight: "0.2",
                                    height: "20",
                                    width: "30",
                                    length: "30",
                                    serviceDeliveryCode: shipping[:service_delivery_code],
                                    productCode: "3",
                                    deliveryReference: "TEST-EOC-17",
                                    groupReference: "GRUPO_libro_la_cuadrilla",
                                    declaredValue: "5",
                                    declaredContent: "string",
                                    extendedCoverageAreaIndicator: false,
                                    receivableAmountInDelivery: 1000
                                  }
                                ]
                            }
                          ]
                        }.to_json
    response = https.request(request)
    response.read_body
    #parseo del response en json y hace return del numero de orden de transporte
    order_number = JSON[response.read_body]
    if geo_reference(shipping) != false
      order_number['data']['detail'][0]['transportOrderNumber'].to_i.to_s
    else
      false
    end
  end
end

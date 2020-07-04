require "uri"
require "net/http"
require "json"
class ApiShipping
  #return del numero orden de transporte, (data.detail.transportOrderNumber)
  API_KEY_GEO_REFERENCE = '8bdf751a989c40e68047dd8bbdfbe4b3'
  API_KEY_ENVIO = '6da83444ca8a4d7a993161e9b39effb8'


  def envio(commune, commune_code, name_address, num_address, observation, contact_name, contact_number, contact_email, service_delivery_code)

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
                                    addressId: geo_reference(commune, name_address, num_address),
                                    countyCoverageCode: commune_code,
                                    streetName: name_address,
                                    streetNumber: num_address,
                                    supplement: "DEFAULT",
                                    addressType: "DEST",
                                    deliveryOnCommercialOffice: false,
                                    commercialOfficeId: "706",
                                    observation: observation
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
                                    name: contact_name,
                                    phoneNumber: contact_number,
                                    mail:contact_email,
                                    contactType: "D"
                                  }
                                ],
                                packages: [
                                  {
                                    weight: "0.2",
                                    height: "20",
                                    width: "30",
                                    length: "30",
                                    serviceDeliveryCode: service_delivery_code,
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
    order_number['data']['detail'][0]['transportOrderNumber']
  end

#return de este es address id para destino.
  def geo_reference(commune, address, num_address)

    url = URI("https://testservices.wschilexpress.com/georeference/api/v1.0/addresses/georeference?Ocp-Apim-Subscription-Key=#{API_KEY_GEO_REFERENCE}")

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = {countyName: commune,
                    streetName: address,
                    number: num_address
                   }.to_json

    response = https.request(request)
    address_id = JSON[response.read_body]
    #return response con el address.id
    address_id['data']['addressId']
  end



end

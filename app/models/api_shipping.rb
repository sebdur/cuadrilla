require "uri"
require "net/http"
require "json"

url = URI("https://testservices.wschilexpress.com/transport-orders/api/v1.0/transport-orders")

https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Ocp-Apim-Subscription-Key"] = "6da83444ca8a4d7a993161e9b39effb8"
request["Content-Type"] = "application/json"
request.body = {  header: {
                            certificateNumber: 0,
                            customerCardNumber: "18578680",
                            countyOfOriginCoverageCode: "PUDA",
                            labelType: 2,
                            marketplaceRut: "96756430",
                            sellerRut: "DEFAULT"
                          },
                        details: [
                        {
                            addresses: [
                              {
                                addressId: 0,
                                countyCoverageCode: "PROV",
                                streetName: "AVENIDA MANUEL MONTT 427",
                                streetNumber: 0,
                                supplement: "",
                                addressType: "DEST",
                                deliveryOnCommercialOffice: true,
                                commercialOfficeId: "706",
                                observation: "DEFAULT"
                              },
                              {
                                addressId: 0,
                                countyCoverageCode: "PLCA",
                                streetName: "SARMIENTO",
                                streetNumber: 120,
                                supplement: "DEFAULT",
                                addressType: "DEV",
                                deliveryOnCommercialOffice: false,
                                observation: "DEFAULT"
                              }
                            ],
                            contacts: [
                              {
                                name: "Claudia Estevez",
                                phoneNumber: "223824861",
                                mail: "cestevez@chilexpress.cl",
                                contactType: "R"
                              },
                              {
                                name": "Marcela Vera",
                                phoneNumber: "227665433",
                                mail:"mevera@chilexpress.cl",
                                contactType: "D"
                              }
                            ],
                            packages: [
                              {
                                weight: "1",
                                height: "1",
                                width: "1",
                                length: "1",
                                serviceDeliveryCode: "3",
                                productCode: "3",
                                deliveryReference: "TEST-EOC-17",
                                groupReference: "GRUPO",
                                declaredValue: "string",
                                declaredContent: "string",
                                extendedCoverageAreaIndicator: false,
                                receivableAmountInDelivery: 1000
                              }
                            ]
                        }
                      ]
                    }
response = https.request(request)
puts response.read_body

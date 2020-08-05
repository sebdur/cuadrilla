class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :phone_number, :body
  validates :name, :email, :phone_number, :body, presence: true

  def send_simple_message
    mailgun = Rails.application.credentials.mailgun[:api_key]
    sandbox = Rails.application.credentials.mailgun[:sandbox]
    RestClient.post "https://api:#{mailgun}"\
    "@api.mailgun.net/v3/#{sandbox}/messages",
    :from => email,
    :to => "sebduran91@gmail.com",
    :subject => "#{name} ha enviado un mensaje a través de www.cuadrilla.cl",
    :text => "Nombre: #{name}\nEmail: #{email}\nTeléfono: #{phone_number}\n\n #{body}"
  end
end

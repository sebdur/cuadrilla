class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :phone_number, :body
  validates :name, :email, :phone_number, :body, presence: true

  def send_simple_message
    RestClient.post "https://api:40193f2859a5fce619d929dd79e65fc4-f135b0f1-55b8ec62"\
    "@api.mailgun.net/v3/sandboxe9bb2e6e645142d0a86e465b3d9d1efe.mailgun.org/messages",
    :from => email,
    :to => "sebduran91@gmail.com",
    :subject => "#{name} ha enviado un mensaje a través de www.cuadrilla.cl",
    :text => "Nombre: #{name}\nEmail: #{email}\nTeléfono: #{phone_number}\n\n #{body}"
  end
end

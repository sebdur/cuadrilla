class MessagesController < Spree::StoreController
  def index
    @message = Message.new
  end

  def create
    @message = Message.new message_params
    if @message.valid?
      @message.send_simple_message
      redirect_to root_path
      flash[:success] = "Mensaje recibido. Te contactaremos a la brevedad!"
    else
      flash[:warning] = "Hubo un problema enviando tu mensaje. Por favor intenta otra vez."
      render :index
    end
  end

private
  def message_params
    params.require(:message).permit(:name, :email, :phone_number, :body)
  end
end

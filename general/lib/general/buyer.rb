class Buyer
  attr_accessor :name, :zip, :address, :number, :complement, :district, :city, :state, :ext, :phone, :email

  def initialize(params = {})
    @name = params[:name]
    @zip = params[:zip]
    @address = params[:address]
    @number = params[:number]
    @complement = params[:complement]
    @district = params[:district]
    @city = params[:city]
    @state = params[:state]
    @ext = params[:ext]
    @phone = params[:phone]
    @email = params[:email]
  end
  
end
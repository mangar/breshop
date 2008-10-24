class Sale

  attr_accessor :code, :buyer, :shipment, :zip1, :zip2, :shipment_type
  attr_reader :itens

#TODO testar este contrutor....
  def initialize(params = {})
    @code = params[:code]
    @buyer = params[:buyer]
    @shipment = params[:shipment]
    @itens = {}
    @itens = params{:itens} if (params.has_key?(:itens))
  end


  #
  # Insert a new item in sale or add an item (quantity) only if
  # the item already been included
  # The parameter must be an Item, or and InvalidItem is throwed
  #
  # Ex.:
  # sale << item
  def <<(item)    
    return if (item.nil?)
    raise InvalidItem unless item.class.eql? Item

    #item is in sale....
    if (@itens.has_key?(item.code))
      
      #quantity eq zero, remove...
      @itens.delete item.code if (item.quantity == 0)

      #change the quantity
      @itens[item.code].quantity = item.quantity if (item.quantity > 0)
      
    else
      @itens[item.code] = item
    end

  end

  # Returns the total price of the sale products
  def price
    price = 0
    return price if (@itens.size == 0)
    @itens.values.each do |item| price += item.price_total end
    price += (@shipment.nil? ? 0 : @shipment)
    price
  end
  
  # Returns the total weight of the all product in the sale
  def weight
    weight = 0
    return weight if (@itens.size == 0)
    @itens.values.each do |item| weight += item.weight_total end
    weight
  end

end
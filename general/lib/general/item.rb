class Item
  attr_accessor :code, :description, :quantity, :price, :weight
  
  def initialize(item = {})
    @code = item[:code]
    @description = item[:description]
    @quantity = item[:quantity]
    @price = item[:price]
    @weight = item[:weight]
  end
  
  def price_total
    @quantity * @price
  end
  
  def weight_total
    @quantity * @weight
  end
  
end
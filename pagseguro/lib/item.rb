class Item
  attr_accessor :id, :descr, :quant, :valor, :weight
  
  def initialize(item = {})
    @id = item[:id]
    @descr = item[:descr]
    @quant = item[:quant]
    @valor = item[:valor]
    @weight = item[:peso]
  end
  
  def total
    @quant * @valor
  end
  
  def weight
    @quant * @weight
  end
  
  
end
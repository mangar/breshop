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

class Items < Array
  def <<(item)
    raise InvalidItem unless item.class.eql? Item
    self.push(item)
  end
  
  def total
    self.map { |i| i.total }.inject { |sum, n| sum + n }
  end
  
  def weight
    self.map { |i| i.weight }.inject { |sum, n| sum + n }
  end
  
  def to_params
    params = []
    
    self.each_with_index do |item, i|
      params << "item_id_#{i+1}=#{item.id}"
      params << "item_descr_#{i+1}=#{URI.escape(item.descr)}"
      params << "item_quant_#{i+1}=#{item.quant}"
      params << "item_valor_#{i+1}=#{item.valor}"
      params << "item_peso_#{i+1}=#{item.weight}"
    end
    
    params
  end
end


class Item
  attr_accessor :codigo, :descricao, :quantidade, :valor, :peso
  
  def initialize(item = {})
    @codigo = item[:codigo]
    @descricao = item[:descricao]
    @quantidade = item[:quantidade]
    @valor = item[:valor]
    @peso = item[:peso]
  end
  
  def valor_total
    @quantidade * @valor
  end
  
  def peso_total
    @quantidade * @peso
  end
  
end
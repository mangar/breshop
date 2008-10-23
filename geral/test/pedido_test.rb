require 'test/unit'
require File.dirname(__FILE__) + '/../lib/geral'

class PedidoTest < Test::Unit::TestCase
  def setup
    @item_1 = Item.new({:codigo=>"1", 
                        :descricao=>"Primeiro Item", 
                        :valor=>10.0, 
                        :quantidade=>1, 
                        :peso=>1.000})
                        
    @item_2 = Item.new({:codigo=>"2", 
                        :descricao=>"Segundo Item", 
                        :valor=>20.0, 
                        :quantidade=>2, 
                        :peso=>2.000})                        
      
    @item_3 = Item.new({:codigo=>"3", 
                        :descricao=>"Terceiro Item", 
                        :valor=>3.99, 
                        :quantidade=>1, 
                        :peso=>0.100})

  end
  
  
  def test_adiciona_item
    @pedido = Pedido.new
    
    assert_equal(0, @pedido.itens.size, "Tamanho de itens deve ser igual a zero (1)")

    @pedido << nil
    assert_equal(0, @pedido.itens.size, "Tamanho de itens deve ser igual a zero (2)")
        
    @pedido << @item_1
    assert_equal(1, @pedido.itens.size, "Tamanho de itens deve ser um (3)")
    
    item = @pedido.itens["1"]
    assert_equal(1, item.quantidade, "Quantidade deve ser 1 (4)")

    @item_1.quantidade = 2
    @pedido << @item_1
    item = @pedido.itens["1"]
    assert_equal(1, @pedido.itens.size, "Tamanho de itens deve ser um (5)")    
    assert_equal(2, item.quantidade, "Quantidade deve ser 2 (6)")

    @item_1.quantidade = 0
    @pedido << @item_1
    item = @pedido.itens["1"]
    assert_equal(0, @pedido.itens.size, "Tamanho de itens deve ser zero (7)")    
    
    @pedido << @item_2
    assert_equal(1, @pedido.itens.size, "Tamanho de itens deve ser um (8)")    
    
    item = @pedido.itens["2"]
    assert_equal(2, item.quantidade, "Quantidade deve ser 2 (9)")    
    
    @item_1.quantidade = 1
    @pedido << @item_1
    assert_equal(2, @pedido.itens.size, "Tamanho de itens deve ser um (10)")        

    item = @pedido.itens["1"]
    assert_equal(1, item.quantidade, "Quantidade deve ser 1 (11)")

    item = @pedido.itens["2"]
    assert_equal(2, item.quantidade, "Quantidade deve ser 2 (12)")    
  
  
    puts "P1.codigo: #{@pedido.codigo}"
    p2 = Pedido.new({:codigo => '123'})
    puts "P2.codigo: #{p2.codigo}"
  
  end
  
  
  def test_valortotal
    @pedido = Pedido.new
    
    assert_equal(0, @pedido.valor, "Valor do pedido deve ser zero (1)")
    
    @pedido << @item_1
    assert_equal(10.0, @pedido.valor, "Valor do pedido deve ser 10.0 (2)")
    assert_equal(1.000, @pedido.peso, "Peso do pedido deve ser 1.000 (3)")

    @item_1.quantidade = 2
    @pedido << @item_1    
    assert_equal(20.0, @pedido.valor, "Valor do pedido deve ser 20.0 (4)")
    assert_equal(2.000, @pedido.peso, "Peso do pedido deve ser 2.000 (5)")

    @pedido << @item_2
    assert_equal(60.0, @pedido.valor, "Valor do pedido deve ser 60.0 (6)")
    assert_equal(6.000, @pedido.peso, "Peso do pedido deve ser 6.000 (7)")

    @pedido.frete = 10.55
    assert_equal(70.55, @pedido.valor, "Valor do pedido deve ser 70.55 (60 de mercadoria + 10.55 de frete) (8)")
    assert_equal(6.000, @pedido.peso, "Peso do pedido deve ser 6.000 (9)")
    
    
    @pedido = Pedido.new
    @pedido << @item_3
    assert_equal(3.99, @pedido.valor, "Valor do pedido deve ser 3.99 (10)")
    assert_equal(0.100, @pedido.peso, "Peso do pedido deve ser 0.100 (11)")

    @item_3.quantidade = 2
    @pedido << @item_3
    assert_equal(7.98, @pedido.valor, "Valor do pedido deve ser 7.98 (12)")
    assert_equal(0.200, @pedido.peso, "Peso do pedido deve ser 0.200 (13)")

  end
  
end
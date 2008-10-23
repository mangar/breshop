require 'test/unit'
require File.dirname(__FILE__) + '/../lib/geral'

class ItemTest < Test::Unit::TestCase
  
  def setup
    @item_1 = Item.new({:codigo=>1, 
                        :descricao=>"Primeiro Item", 
                        :valor=>100.0, 
                        :quantidade=>2, 
                        :peso=>10})
  end
  
  def test_obtendo_peso_total    
    assert_equal(10, @item_1.peso)
  end
  
  def test_obtendo_preco_total
    assert_equal(100, @item_1.valor)
  end
  
  
end

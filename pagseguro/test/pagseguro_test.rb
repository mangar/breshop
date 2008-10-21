require 'test/unit'
require File.dirname(__FILE__) + '/../lib/item'
require File.dirname(__FILE__) + '/../lib/pagseguro'

class PagseguroTest < Test::Unit::TestCase
  
  def setup
    @item_1 = Item.new({:id=>1, 
                        :descr=>"Primeiro Item", 
                        :valor=>10.0, 
                        :quant=>1, 
                        :peso=>1000})
                        
    @item_2 = Item.new({:id=>2,
                        :descr=>"Segundo Item", 
                        :valor=>15.0, 
                        :quant=>2,
                        :peso=>500})
                        
    @pagseguro = Pagseguro.new
  end
  
  def test_adding_some_items
    assert_equal(0, @pagseguro.items.size)
    @pagseguro << @item_1
    assert_equal(1, @pagseguro.items.size)
    
    assert_raise(InvalidItem) { @pagseguro << "" }
    assert_raise(InvalidItem) { @pagseguro << 1 }
  end
  
  def test_getting_valor_total
    @pagseguro << @item_1
    @pagseguro << @item_2
    
    assert_equal(40, @pagseguro.total)
  end
  
  def test_getting_peso_total
    @pagseguro << @item_1
    @pagseguro << @item_2
    
    assert_equal(2000, @pagseguro.weight)
  end
  
  def test_shipping
    @pagseguro << @item_1
    
    assert_equal("8,80", @pagseguro.shipping("05116050", "EN"))
    assert_equal("10,20", @pagseguro.shipping("05116050", "SD"))
    
    @pagseguro << @item_2
    assert_equal("10,20", @pagseguro.shipping("05116050", "EN"))
    assert_equal("12,60", @pagseguro.shipping("05116050", "SD"))
  end
  
end

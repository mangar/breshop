require 'test/unit'
require File.dirname(__FILE__) + '/../lib/item'
require File.dirname(__FILE__) + '/../lib/items'

class ItemsTest < Test::Unit::TestCase
  
  def setup
    @item_1 = Item.new({:id=>1, 
                        :descr=>"Primeiro Item", 
                        :valor=>10.0, 
                        :quant=>1, 
                        :peso=>10})
                        
    @item_2 = Item.new({:id=>2, 
                        :descr=>"Segundo Item", 
                        :valor=>15.0, 
                        :quant=>2,
                        :peso=>5})
                        
    @items = Items.new
  end
  
  def test_adding_some_items
    assert_equal(0, @items.size)
    @items << @item_1
    assert_equal(1, @items.size)
    
    assert_raise(InvalidItem) { @items << "" }
    assert_raise(InvalidItem) { @items << 1 }
  end
  
  def test_getting_price_total
    @items << @item_1
    @items << @item_2
    
    assert_equal(40, @items.total)
  end
  
  def test_getting_weight_total
    @items << @item_1
    @items << @item_2
    
    assert_equal(20, @items.weight)
  end
  
  def test_turning_items_in_params
    @items << @item_1
    
    assert_equal(["item_id_1=1","item_descr_1=Primeiro%20Item","item_quant_1=1","item_valor_1=10.0","item_peso_1=10"], @items.to_params)
  end
  
end
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/general'

class ItemTest < Test::Unit::TestCase

  def setup
    @item_1 = Item.new({:code=>1,
                        :description=>"Primeiro Item",
                        :price=>100.0,
                        :quantity=>2,
                        :weight=>10})
  end

  def test_obtendo_peso_total
    assert_equal(10, @item_1.weight)
  end

  def test_obtendo_preco_total
    assert_equal(100, @item_1.price)
  end


end

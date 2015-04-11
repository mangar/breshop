require 'test/unit'
require File.dirname(__FILE__) + '/../lib/general'

class SalesTest < Test::Unit::TestCase
  def setup
    @item_1 = Item.new({:code=>"1",
                        :description=>"Primeiro Item",
                        :price=>10.0,
                        :quantity=>1,
                        :weight=>1.000})

    @item_2 = Item.new({:code=>"2",
                        :description=>"Segundo Item",
                        :price=>20.0,
                        :quantity=>2,
                        :weight=>2.000})

    @item_3 = Item.new({:code=>"3",
                        :description=>"Terceiro Item",
                        :price=>3.99,
                        :quantity=>1,
                        :weight=>0.100})

  end


  def test_adiciona_item
    @sale = Sale.new

    assert_equal(0, @sale.itens.size, "Tamanho de itens deve ser igual a zero (1)")

    @sale << nil
    assert_equal(0, @sale.itens.size, "Tamanho de itens deve ser igual a zero (2)")

    @sale << @item_1
    assert_equal(1, @sale.itens.size, "Tamanho de itens deve ser um (3)")

    item = @sale.itens["1"]
    assert_equal(1, item.quantity, "Quantidade deve ser 1 (4)")

    @item_1.quantity = 2
    @sale << @item_1
    item = @sale.itens["1"]
    assert_equal(1, @sale.itens.size, "Tamanho de itens deve ser um (5)")
    assert_equal(2, item.quantity, "Quantidade deve ser 2 (6)")

    @item_1.quantity = 0
    @sale << @item_1
    item = @sale.itens["1"]
    assert_equal(0, @sale.itens.size, "Tamanho de itens deve ser zero (7)")

    @sale << @item_2
    assert_equal(1, @sale.itens.size, "Tamanho de itens deve ser um (8)")

    item = @sale.itens["2"]
    assert_equal(2, item.quantity, "Quantidade deve ser 2 (9)")

    @item_1.quantity = 1
    @sale << @item_1
    assert_equal(2, @sale.itens.size, "Tamanho de itens deve ser um (10)")

    item = @sale.itens["1"]
    assert_equal(1, item.quantity, "Quantidade deve ser 1 (11)")

    item = @sale.itens["2"]
    assert_equal(2, item.quantity, "Quantidade deve ser 2 (12)")


    puts "P1.code: #{@sale.code}"
    p2 = Sale.new({:code => '123'})
    puts "P2.code: #{p2.code}"

  end


  def test_pricetotal
    @sale = Sale.new

    assert_equal(0, @sale.price, "Valor do sale deve ser zero (1)")

    @sale << @item_1
    assert_equal(10.0, @sale.price, "Valor do sale deve ser 10.0 (2)")
    assert_equal(1.000, @sale.weight, "Peso do sale deve ser 1.000 (3)")

    @item_1.quantity = 2
    @sale << @item_1
    assert_equal(20.0, @sale.price, "Valor do sale deve ser 20.0 (4)")
    assert_equal(2.000, @sale.weight, "Peso do sale deve ser 2.000 (5)")

    @sale << @item_2
    assert_equal(60.0, @sale.price, "Valor do sale deve ser 60.0 (6)")
    assert_equal(6.000, @sale.weight, "Peso do sale deve ser 6.000 (7)")

    @sale.shipment = 10.55
    assert_equal(70.55, @sale.price, "Valor do sale deve ser 70.55 (60 de mercadoria + 10.55 de shipment) (8)")
    assert_equal(6.000, @sale.weight, "Peso do sale deve ser 6.000 (9)")


    @sale = Sale.new
    @sale << @item_3
    assert_equal(3.99, @sale.price, "Valor do sale deve ser 3.99 (10)")
    assert_equal(0.100, @sale.weight, "Peso do sale deve ser 0.100 (11)")

    @item_3.quantity = 2
    @sale << @item_3
    assert_equal(7.98, @sale.price, "Valor do sale deve ser 7.98 (12)")
    assert_equal(0.200, @sale.weight, "Peso do sale deve ser 0.200 (13)")

  end

end
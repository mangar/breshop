require 'test/unit'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/pagseguro'
require File.dirname(__FILE__) + '/../../general/lib/general'

class PagseguroTest < Test::Unit::TestCase
  
  def setup
    @item_1 = Item.new({:code=>"1",
                        :description=>"Descricao do Produto 01",
                        :quantity=>1,
                        :price=>11.50,
                        :weight=>0.100})

    @item_2 = Item.new({:code=>"2",
                        :description=>"Descricao do Produto 02",
                        :quantity=>2,
                        :price=>22.30,
                        :weight=>0.500})

                        
    @config = YAML.load_file(File.dirname(__FILE__) + '/pagseguro_test.yml')
  end
  
  
  def test_to_weight
    pagseguro = Integration.new
    
    #1.1 - nil
    price = pagseguro.to_weight nil
    assert_nil price, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
    
    #1.2 - price nao conversivel a decimal
    price = pagseguro.to_weight "abc"
    assert_equal "000", price, "1.2 - o price deve ser conversivel a decimal, caso contrario retornara o weight zerado no formado PS (000)"
  
    #1.3 - price deve ser uma String
    price = pagseguro.to_weight 14
    assert_nil nil, "1.3 - price deve ser uma string"
  
    #2 - entradas validas
    price = pagseguro.to_weight "0.5"
    assert_equal "500", price, "2.1 - 0.5 => 500"
  
    price = pagseguro.to_weight "0.50"
    assert_equal "500", price, "2.2 - 0.50 => 500"
  
    price = pagseguro.to_weight "0.500"
    assert_equal "500", price, "2.3 - 0.500 => 500"
  
    price = pagseguro.to_weight "0.05"
    assert_equal "050", price, "2.4 - 0.05 => 050"
  
    price = pagseguro.to_weight "0.005"
    assert_equal "005", price, "2.5 - 0.05 => 005"
     
    price = pagseguro.to_weight "1"
    assert_equal "1000", price, "2.6 - 1 => 1000"
    
    price = pagseguro.to_weight "1.0"
    assert_equal "1000", price, "2.7 - 1.0 => 1000"     
     
    price = pagseguro.to_weight "1.5"
    assert_equal "1500", price, "2.8 - 1.5 => 1500"     
     
    price = pagseguro.to_weight "1.500"
    assert_equal "1500", price, "2.9 - 1.500 => 1500"
    
    price = pagseguro.to_weight "1.501"
    assert_equal "1501", price, "2.10 - 1.501 => 1501"
    
    price = pagseguro.to_weight "1.510"
    assert_equal "1510", price, "2.11 - 1.510 => 1510"     

    price = pagseguro.to_weight "0.1"
    assert_equal "100", price, "2.12 - 0.1 => 100"     

     
  end
  
  def test_to_money
    pagseguro = Integration.new
  
    #1.1 - nil
    price = pagseguro.to_money nil
    assert_nil price, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
    
    #1.2 - price nao conversivel a decimal
    price = pagseguro.to_money "abc"
    assert_equal "00", price, "1.2 - o price deve ser conversivel a decimal, caso contrario retornara o weight zerado no formado PS (000)"
  
    #1.3 - price deve ser uma String
    price = pagseguro.to_money 14
    assert_nil nil, "1.3 - price deve ser uma string"
        
    #2 - entradas validas 
    price = pagseguro.to_money "0.5"
    assert_equal "50", price, "2.1 - 0.5 => 50 centavos"
    
    price = pagseguro.to_money "0.50"
    assert_equal "50", price, "2.2 - 0.50 => 50 centavos"
    
    price = pagseguro.to_money "0.05"
    assert_equal "05", price, "2.3 - 0.05 => 05 centavos"
    
    price = pagseguro.to_money "1"
    assert_equal "100", price, "2.4 - 1 => 1 real (100)"
    
    price = pagseguro.to_money "1.0"
    assert_equal "100", price, "2.5 - 1.0 => 1 real (100)"
    
    price = pagseguro.to_money "1.5"
    assert_equal "150", price, "2.6 - 1.5 => 1,5 real"
    
    price = pagseguro.to_money "1.55"
    assert_equal "155", price, "2.7 - 1.55 => 1,55 real"
    
    price = pagseguro.to_money "1.05"
    assert_equal "105", price, "2.8 - 1.05 => 105 real (100)"
    
    price = pagseguro.to_money "0.05"
    assert_equal "05", price, "2.9 - 0.05 => 05 real"
    
  end
  
  def test_checkout
    pagseguro = Integration.new
    
    sale = Sale.new
    
    # sale nil
    assert_raise RuntimeError do pagseguro.checkout nil; end
    
    # sale.buyer nil
    assert_raise RuntimeError do pagseguro.checkout sale end
    
    # sale.buyer = "some name"
    sale.buyer = "Some Name"
    assert_raise RuntimeError do pagseguro.checkout sale end
    buyer = Buyer.new
    sale.buyer = Buyer.new
    
    # itens qt == 0.
    assert_raise RuntimeError do pagseguro.checkout sale end
    sale << @item_1
    
    
    sale.buyer.name = "Marcio Garcia"
    sale.code = "TC01"
    sale.buyer.zip = "04515030"
    sale.buyer.address = "Av. Jacutinga"
    sale.buyer.number = "632"
    sale.buyer.complement = "AP22"
    sale.buyer.district = "Moema"
    sale.buyer.city = "Sao Paulo"
    sale.buyer.state = "SP"
    sale.buyer.email = "email@uol.com.br"
    sale.buyer.ext = "11"
    sale.buyer.phone = "86717148"
    sale.shipment_type = "EN"
        
    assert_equal(self.return_form_pac_one_product, pagseguro.checkout(sale), "Shipment type defined by the seller, calculated by weight (EN = PAC)")
    
    sale.shipment_type = "SD"
    assert_equal(self.return_form_sedex_one_product, pagseguro.checkout(sale), "Shipment type defined by the seller, calculated by weight (SD = SEDEX)")

    sale.shipment_type = nil
    assert_equal(self.return_form_one_product, pagseguro.checkout(sale), "Buyer will select the shipment type and price on PagSeguro")
  
    assert_equal(self.return_form_defined_one_product, pagseguro.checkout(sale, 1000), "Shipment fee defined by seller = R$10,00")

    sale.shipment_type = "SD"
    assert_equal(self.return_form_defined_one_product, pagseguro.checkout(sale, 1000), "Shipment fee defined by seller = R$10,00")

    sale.shipment_type = "EN"
    assert_equal(self.return_form_defined_one_product, pagseguro.checkout(sale, 1000), "Shipment fee defined by seller = R$10,00")
    
  end
  
  def return_form_sedex_one_product
    data = "<form action=\"https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx\" method=\"post\" name=\"payment_form\"> \n <input type=\"hidden\" name=\"ref_transacao\" value=\"TC01\" /> \n <input type=\"hidden\" name=\"email_cobranca\" value=\"marcio.mangar@uol.com.br\" /> \n <input type=\"hidden\" name=\"tipo\" value=\"CP\" /> \n <input type=\"hidden\" name=\"moeda\" value=\"BRL\" /> \n <input type=\"hidden\" name=\"cliente_pais\" value=\"BRA\" /> \n <input type=\"hidden\" name=\"cliente_nome\" value=\"Marcio Garcia\" /> \n <input type=\"hidden\" name=\"cliente_cep\" value=\"04515030\" /> \n <input type=\"hidden\" name=\"cliente_end\" value=\"Av. Jacutinga\" /> \n <input type=\"hidden\" name=\"cliente_num\" value=\"632\" /> \n <input type=\"hidden\" name=\"cliente_compl\" value=\"AP22\" /> \n <input type=\"hidden\" name=\"cliente_bairro\" value=\"Moema\" /> \n <input type=\"hidden\" name=\"cliente_cidade\" value=\"Sao Paulo\" /> \n <input type=\"hidden\" name=\"cliente_uf\" value=\"SP\" /> \n <input type=\"hidden\" name=\"cliente_ddd\" value=\"11\" /> \n <input type=\"hidden\" name=\"cliente_tel\" value=\"86717148\" /> \n <input type=\"hidden\" name=\"cliente_email\" value=\"email@uol.com.br\" /> \n <input type=\"hidden\" name=\"tipo_frete\" value=\"SD\" /> \n <input type=\"hidden\" name=\"item_id_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_descr_1\" value=\"Descricao do Produto 01\" /> \n <input type=\"hidden\" name=\"item_quant_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_valor_1\" value=\"1150\" /> \n <input type=\"hidden\" name=\"item_peso_1\" value=\"100\" /> \n<input type=\"submit\" /> \n</form>" 
  end
  
  def return_form_pac_one_product
    data = "<form action=\"https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx\" method=\"post\" name=\"payment_form\"> \n <input type=\"hidden\" name=\"ref_transacao\" value=\"TC01\" /> \n <input type=\"hidden\" name=\"email_cobranca\" value=\"marcio.mangar@uol.com.br\" /> \n <input type=\"hidden\" name=\"tipo\" value=\"CP\" /> \n <input type=\"hidden\" name=\"moeda\" value=\"BRL\" /> \n <input type=\"hidden\" name=\"cliente_pais\" value=\"BRA\" /> \n <input type=\"hidden\" name=\"cliente_nome\" value=\"Marcio Garcia\" /> \n <input type=\"hidden\" name=\"cliente_cep\" value=\"04515030\" /> \n <input type=\"hidden\" name=\"cliente_end\" value=\"Av. Jacutinga\" /> \n <input type=\"hidden\" name=\"cliente_num\" value=\"632\" /> \n <input type=\"hidden\" name=\"cliente_compl\" value=\"AP22\" /> \n <input type=\"hidden\" name=\"cliente_bairro\" value=\"Moema\" /> \n <input type=\"hidden\" name=\"cliente_cidade\" value=\"Sao Paulo\" /> \n <input type=\"hidden\" name=\"cliente_uf\" value=\"SP\" /> \n <input type=\"hidden\" name=\"cliente_ddd\" value=\"11\" /> \n <input type=\"hidden\" name=\"cliente_tel\" value=\"86717148\" /> \n <input type=\"hidden\" name=\"cliente_email\" value=\"email@uol.com.br\" /> \n <input type=\"hidden\" name=\"tipo_frete\" value=\"EN\" /> \n <input type=\"hidden\" name=\"item_id_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_descr_1\" value=\"Descricao do Produto 01\" /> \n <input type=\"hidden\" name=\"item_quant_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_valor_1\" value=\"1150\" /> \n <input type=\"hidden\" name=\"item_peso_1\" value=\"100\" /> \n<input type=\"submit\" /> \n</form>" 
  end
  
  def return_form_one_product
    data = "<form action=\"https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx\" method=\"post\" name=\"payment_form\"> \n <input type=\"hidden\" name=\"ref_transacao\" value=\"TC01\" /> \n <input type=\"hidden\" name=\"email_cobranca\" value=\"marcio.mangar@uol.com.br\" /> \n <input type=\"hidden\" name=\"tipo\" value=\"CP\" /> \n <input type=\"hidden\" name=\"moeda\" value=\"BRL\" /> \n <input type=\"hidden\" name=\"cliente_pais\" value=\"BRA\" /> \n <input type=\"hidden\" name=\"cliente_nome\" value=\"Marcio Garcia\" /> \n <input type=\"hidden\" name=\"cliente_cep\" value=\"04515030\" /> \n <input type=\"hidden\" name=\"cliente_end\" value=\"Av. Jacutinga\" /> \n <input type=\"hidden\" name=\"cliente_num\" value=\"632\" /> \n <input type=\"hidden\" name=\"cliente_compl\" value=\"AP22\" /> \n <input type=\"hidden\" name=\"cliente_bairro\" value=\"Moema\" /> \n <input type=\"hidden\" name=\"cliente_cidade\" value=\"Sao Paulo\" /> \n <input type=\"hidden\" name=\"cliente_uf\" value=\"SP\" /> \n <input type=\"hidden\" name=\"cliente_ddd\" value=\"11\" /> \n <input type=\"hidden\" name=\"cliente_tel\" value=\"86717148\" /> \n <input type=\"hidden\" name=\"cliente_email\" value=\"email@uol.com.br\" /> \n <input type=\"hidden\" name=\"item_id_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_descr_1\" value=\"Descricao do Produto 01\" /> \n <input type=\"hidden\" name=\"item_quant_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_valor_1\" value=\"1150\" /> \n <input type=\"hidden\" name=\"item_peso_1\" value=\"100\" /> \n<input type=\"submit\" /> \n</form>" 
  end  
  
  def return_form_defined_one_product
    data = "<form action=\"https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx\" method=\"post\" name=\"payment_form\"> \n <input type=\"hidden\" name=\"ref_transacao\" value=\"TC01\" /> \n <input type=\"hidden\" name=\"email_cobranca\" value=\"marcio.mangar@uol.com.br\" /> \n <input type=\"hidden\" name=\"tipo\" value=\"CP\" /> \n <input type=\"hidden\" name=\"moeda\" value=\"BRL\" /> \n <input type=\"hidden\" name=\"cliente_pais\" value=\"BRA\" /> \n <input type=\"hidden\" name=\"cliente_nome\" value=\"Marcio Garcia\" /> \n <input type=\"hidden\" name=\"cliente_cep\" value=\"04515030\" /> \n <input type=\"hidden\" name=\"cliente_end\" value=\"Av. Jacutinga\" /> \n <input type=\"hidden\" name=\"cliente_num\" value=\"632\" /> \n <input type=\"hidden\" name=\"cliente_compl\" value=\"AP22\" /> \n <input type=\"hidden\" name=\"cliente_bairro\" value=\"Moema\" /> \n <input type=\"hidden\" name=\"cliente_cidade\" value=\"Sao Paulo\" /> \n <input type=\"hidden\" name=\"cliente_uf\" value=\"SP\" /> \n <input type=\"hidden\" name=\"cliente_ddd\" value=\"11\" /> \n <input type=\"hidden\" name=\"cliente_tel\" value=\"86717148\" /> \n <input type=\"hidden\" name=\"cliente_email\" value=\"email@uol.com.br\" /> \n <input type=\"hidden\" name=\"item_frete_1\" value=\"1000\" /> \n <input type=\"hidden\" name=\"item_id_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_descr_1\" value=\"Descricao do Produto 01\" /> \n <input type=\"hidden\" name=\"item_quant_1\" value=\"1\" /> \n <input type=\"hidden\" name=\"item_valor_1\" value=\"1150\" /> \n <input type=\"hidden\" name=\"item_peso_1\" value=\"100\" /> \n<input type=\"submit\" /> \n</form>" 
  end  
  
  
end
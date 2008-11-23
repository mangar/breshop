require 'test/unit'
require 'yaml'
require 'rubygems'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/pagseguro'
require File.dirname(__FILE__) + '/../../general/lib/general'

class PagseguroTest < Test::Unit::TestCase
 
  PAGSEGURO_YML = {"pagseguro" => {'email_cobranca' => "email@servidor.com",
                                   'tipo_carrinho' => "CP",
                                   'moeda'         => "BRL",
                                   'pais'          => "BRA",
                                   'webpagto'      => "https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx"}}
   
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

  end
 
  def test_integration_constructor_load_breshop_yml_in_config_rails_folder
    integration = Integration.new(:config=> File.dirname(__FILE__) + "/../../install/breshop.yml" )
    assert_equal PAGSEGURO_YML["pagseguro"], integration.instance_variable_get("@config")   
  end
 
  def test_to_weight
    assert_equal @item_1.weight.to_ps_weight, "100"
    
    #1.1 - nil
    price = nil.to_ps_weight
    assert_nil price, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
   
    #1.2 - price nao conversivel a decimal
    price = "abc".to_ps_weight
    assert_equal "000", price, "1.2 - o price deve ser conversivel a decimal, caso contrario retornara o weight zerado no formado PS (000)"
 
    #1.3 - price deve ser uma String
    price = 14.to_ps_weight
    assert_nil nil, "1.3 - price deve ser uma string"
 
    #2 - entradas validas
    price = "0.5".to_ps_weight
    assert_equal "500", price, "2.1 - 0.5 => 500"
 
    price = "0.50".to_ps_weight
    assert_equal "500", price, "2.2 - 0.50 => 500"
 
    price = "0.500".to_ps_weight
    assert_equal "500", price, "2.3 - 0.500 => 500"
 
    price = "0.05".to_ps_weight
    assert_equal "050", price, "2.4 - 0.05 => 050"
 
    price = "0.005".to_ps_weight
    assert_equal "005", price, "2.5 - 0.05 => 005"
    
    price = "1".to_ps_weight
    assert_equal "1000", price, "2.6 - 1 => 1000"
   
    price = "1.0".to_ps_weight
    assert_equal "1000", price, "2.7 - 1.0 => 1000"    
    
    price = "1.5".to_ps_weight
    assert_equal "1500", price, "2.8 - 1.5 => 1500"    
    
    price = "1.500".to_ps_weight
    assert_equal "1500", price, "2.9 - 1.500 => 1500"
   
    price = "1.501".to_ps_weight
    assert_equal "1501", price, "2.10 - 1.501 => 1501"
   
    price = "1.510".to_ps_weight
    assert_equal "1510", price, "2.11 - 1.510 => 1510"    

    price = "0.1".to_ps_weight
    assert_equal "100", price, "2.12 - 0.1 => 100"    
  end
 
  def test_to_money
    
    assert_equal @item_1.price.to_ps_money, "1150"
    #1.1 - nil
    price = nil.to_ps_money
    assert_nil price, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
   
    #1.2 - price nao conversivel a decimal
    price = "abc".to_ps_money
    assert_equal "00", price, "1.2 - o price deve ser conversivel a decimal, caso contrario retornara o weight zerado no formado PS (000)"
 
    #1.3 - price deve ser uma String
    price = 14.to_ps_money
    assert_nil nil, "1.3 - price deve ser uma string"
       
    #2 - entradas validas
    price = "0.5".to_ps_money
    assert_equal "50", price, "2.1 - 0.5 => 50 centavos"
   
    price = "0.50".to_ps_money
    assert_equal "50", price, "2.2 - 0.50 => 50 centavos"
   
    price = "0.05".to_ps_money
    assert_equal "05", price, "2.3 - 0.05 => 05 centavos"
   
    price = "1".to_ps_money
    assert_equal "100", price, "2.4 - 1 => 1 real (100)"
   
    price = "1.0".to_ps_money
    assert_equal "100", price, "2.5 - 1.0 => 1 real (100)"
   
    price = "1.5".to_ps_money
    assert_equal "150", price, "2.6 - 1.5 => 1,5 real"
   
    price = "1.55".to_ps_money
    assert_equal "155", price, "2.7 - 1.55 => 1,55 real"
   
    price = "1.05".to_ps_money
    assert_equal "105", price, "2.8 - 1.05 => 105 real (100)"
   
    price = "0.05".to_ps_money
    assert_equal "05", price, "2.9 - 0.05 => 05 real"
   
  end
 
  def test_checkout
    pagseguro = Integration.new(:config=>File.dirname(__FILE__) + "/../../install/breshop.yml")
   
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
    data = "<!-- start template -->\n<form action='https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx' method='post' name='payment_form'>\n  <input name='ref_transacao' type='hidden' value='TC01' />\n  <input name='email_cobranca' type='hidden' value='email@servidor.com' />\n  <input name='tipo' type='hidden' value='CP' />\n  <input name='moeda' type='hidden' value='BRL' />\n  <input name='cliente_pais' type='hidden' value='BRA' />\n  <input name='cliente_nome' type='hidden' value='Marcio Garcia' />\n  <input name='cliente_cep' type='hidden' value='04515030' />\n  <input name='cliente_end' type='hidden' value='Av. Jacutinga' />\n  <input name='cliente_num' type='hidden' value='632' />\n  <input name='cliente_compl' type='hidden' value='AP22' />\n  <input name='cliente_bairro' type='hidden' value='Moema' />\n  <input name='cliente_cidade' type='hidden' value='Sao Paulo' />\n  <input name='cliente_uf' type='hidden' value='SP' />\n  <input name='cliente_ddd' type='hidden' value='11' />\n  <input name='cliente_tel' type='hidden' value='86717148' />\n  <input name='cliente_email' type='hidden' value='email@uol.com.br' />\n  <input name='tipo_frete' type='hidden' value='SD' />\n  <input name='item_id_1' type='hidden' value='1' />\n  <input name='item_descr_1' type='hidden' value='Descricao do Produto 01' />\n  <input name='item_quant_1' type='hidden' value='1' />\n  <input name='item_valor_1' type='hidden' value='1150' />\n  <input name='item_peso_1' type='hidden' value='100' />\n  <input type='submit' />\n</form>\n<!-- end template -->\n"
  end
 
  def return_form_pac_one_product
    data = "<!-- start template -->\n<form action='https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx' method='post' name='payment_form'>\n  <input name='ref_transacao' type='hidden' value='TC01' />\n  <input name='email_cobranca' type='hidden' value='email@servidor.com' />\n  <input name='tipo' type='hidden' value='CP' />\n  <input name='moeda' type='hidden' value='BRL' />\n  <input name='cliente_pais' type='hidden' value='BRA' />\n  <input name='cliente_nome' type='hidden' value='Marcio Garcia' />\n  <input name='cliente_cep' type='hidden' value='04515030' />\n  <input name='cliente_end' type='hidden' value='Av. Jacutinga' />\n  <input name='cliente_num' type='hidden' value='632' />\n  <input name='cliente_compl' type='hidden' value='AP22' />\n  <input name='cliente_bairro' type='hidden' value='Moema' />\n  <input name='cliente_cidade' type='hidden' value='Sao Paulo' />\n  <input name='cliente_uf' type='hidden' value='SP' />\n  <input name='cliente_ddd' type='hidden' value='11' />\n  <input name='cliente_tel' type='hidden' value='86717148' />\n  <input name='cliente_email' type='hidden' value='email@uol.com.br' />\n  <input name='tipo_frete' type='hidden' value='EN' />\n  <input name='item_id_1' type='hidden' value='1' />\n  <input name='item_descr_1' type='hidden' value='Descricao do Produto 01' />\n  <input name='item_quant_1' type='hidden' value='1' />\n  <input name='item_valor_1' type='hidden' value='1150' />\n  <input name='item_peso_1' type='hidden' value='100' />\n  <input type='submit' />\n</form>\n<!-- end template -->\n"
  end
 
  def return_form_one_product
    data = "<!-- start template -->\n<form action='https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx' method='post' name='payment_form'>\n  <input name='ref_transacao' type='hidden' value='TC01' />\n  <input name='email_cobranca' type='hidden' value='email@servidor.com' />\n  <input name='tipo' type='hidden' value='CP' />\n  <input name='moeda' type='hidden' value='BRL' />\n  <input name='cliente_pais' type='hidden' value='BRA' />\n  <input name='cliente_nome' type='hidden' value='Marcio Garcia' />\n  <input name='cliente_cep' type='hidden' value='04515030' />\n  <input name='cliente_end' type='hidden' value='Av. Jacutinga' />\n  <input name='cliente_num' type='hidden' value='632' />\n  <input name='cliente_compl' type='hidden' value='AP22' />\n  <input name='cliente_bairro' type='hidden' value='Moema' />\n  <input name='cliente_cidade' type='hidden' value='Sao Paulo' />\n  <input name='cliente_uf' type='hidden' value='SP' />\n  <input name='cliente_ddd' type='hidden' value='11' />\n  <input name='cliente_tel' type='hidden' value='86717148' />\n  <input name='cliente_email' type='hidden' value='email@uol.com.br' />\n  <input name='item_id_1' type='hidden' value='1' />\n  <input name='item_descr_1' type='hidden' value='Descricao do Produto 01' />\n  <input name='item_quant_1' type='hidden' value='1' />\n  <input name='item_valor_1' type='hidden' value='1150' />\n  <input name='item_peso_1' type='hidden' value='100' />\n  <input type='submit' />\n</form>\n<!-- end template -->\n"
  end 
 
  def return_form_defined_one_product
    data = "<!-- start template -->\n<form action='https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx' method='post' name='payment_form'>\n  <input name='ref_transacao' type='hidden' value='TC01' />\n  <input name='email_cobranca' type='hidden' value='email@servidor.com' />\n  <input name='tipo' type='hidden' value='CP' />\n  <input name='moeda' type='hidden' value='BRL' />\n  <input name='cliente_pais' type='hidden' value='BRA' />\n  <input name='cliente_nome' type='hidden' value='Marcio Garcia' />\n  <input name='cliente_cep' type='hidden' value='04515030' />\n  <input name='cliente_end' type='hidden' value='Av. Jacutinga' />\n  <input name='cliente_num' type='hidden' value='632' />\n  <input name='cliente_compl' type='hidden' value='AP22' />\n  <input name='cliente_bairro' type='hidden' value='Moema' />\n  <input name='cliente_cidade' type='hidden' value='Sao Paulo' />\n  <input name='cliente_uf' type='hidden' value='SP' />\n  <input name='cliente_ddd' type='hidden' value='11' />\n  <input name='cliente_tel' type='hidden' value='86717148' />\n  <input name='cliente_email' type='hidden' value='email@uol.com.br' />\n  <input name='item_frete_1' type='hidden' value='1000' />\n  <input name='item_id_1' type='hidden' value='1' />\n  <input name='item_descr_1' type='hidden' value='Descricao do Produto 01' />\n  <input name='item_quant_1' type='hidden' value='1' />\n  <input name='item_valor_1' type='hidden' value='1150' />\n  <input name='item_peso_1' type='hidden' value='100' />\n  <input type='submit' />\n</form>\n<!-- end template -->\n"
  end 
 
 
end
require 'rubygems'
require 'uri'
require 'net/http'
require 'net/https'
require 'hpricot'
require "erb"

class Integration
    
  # Integration can be instantiated using a config file as parameter
  # if no one is specified, will be used the default: /../config/pageguro.yml
  #
  def initialize(pars = {})
    
    @config = (pars[:config].nil? ? YAML.load_file(File.dirname(__FILE__) + "/../../../../../../config/breshop.yml")["pagseguro"] : pars[:config])

    @parametros_config = "tipo=#{@config['tipo_carrinho']}"
    @parametros_config << "&moeda=#{@config['moeda']}"
    @parametros_config << "&email_cobranca=#{@config['email_cobranca']}"
    
    @uri = URI.parse(@config['webpagto'])
  end

  # Cria o formulario no formato HTML para o post que será enviado ao site do PagSeguro
  # 
  # Ex.:
  # @form_html = integration.checkout sale ==> no shipment fee defined, will be calculated by PagSeguro
  #              if you define shipment_type (SD/EN) it will be used by PagSeguro, if not, the buyer will 
  #              select one of then as shipment
  # @form_html = integration.checkout sale, "10.00" ==> fixed shipment fee 
  #
  #TODO test
  #TODO colocar em um helper (??)
  def checkout sale, *frete

    raise "Invalid Sale" if sale.nil?
    raise "Invalid buyer! (nil)" if sale.buyer.nil?
    raise "Invalid buyer! (not a Buyer)" unless sale.buyer.class.eql? Buyer
    raise "Invalid Itens! (qt = 0)" if sale.itens.size == 0
    
    
    data =  "<form action=\"#{@config['webpagto']}\" method=\"post\" name=\"payment_form\"> \n"
    data += " <input type=\"hidden\" name=\"ref_transacao\" value=\"#{sale.code}\" /> \n"
    data += " <input type=\"hidden\" name=\"email_cobranca\" value=\"#{@config['email_cobranca']}\" /> \n"
    data += " <input type=\"hidden\" name=\"tipo\" value=\"#{@config['tipo_carrinho']}\" /> \n"
    data += " <input type=\"hidden\" name=\"moeda\" value=\"#{@config['moeda']}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_pais\" value=\"#{@config['pais']}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_nome\" value=\"#{sale.buyer.name}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_cep\" value=\"#{sale.buyer.zip}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_end\" value=\"#{sale.buyer.address}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_num\" value=\"#{sale.buyer.number}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_compl\" value=\"#{sale.buyer.complement}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_bairro\" value=\"#{sale.buyer.district}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_cidade\" value=\"#{sale.buyer.city}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_uf\" value=\"#{sale.buyer.state}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_ddd\" value=\"#{sale.buyer.ext}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_tel\" value=\"#{sale.buyer.phone}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_email\" value=\"#{sale.buyer.email}\" /> \n"
    
    # shipment type...
    # if no shipment_type is not specified and also shipment price, 
    # the buyer will be asked, to select one
    #
    # https://pagseguro.uol.com.br/Security/WebPagamentos/ConfigWebPagto.aspx
    #
    if (frete.empty?)
      #... calculated price, based on the weight and shipment type, calculated by PagSeguro
      # configure on the PagSeguro: https://pagseguro.uol.com.br/Security/WebPagamentos/ConfigWebPagto.aspx (Frete por peso)
      data += " <input type=\"hidden\" name=\"tipo_frete\" value=\"#{sale.shipment_type}\" /> \n" unless sale.shipment_type.nil?
    else
      #... fixed price
      # configure on the PagSeguro: https://pagseguro.uol.com.br/Security/WebPagamentos/ConfigWebPagto.aspx (Frete fixo com desconto)
      data += " <input type=\"hidden\" name=\"item_frete_1\" value=\"#{frete.first}\" /> \n"      
    end
    
    sale.itens.values.each_with_index do |item, i|
      data += " <input type=\"hidden\" name=\"item_id_#{i+1}\" value=\"#{item.code}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_descr_#{i+1}\" value=\"#{item.description}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_quant_#{i+1}\" value=\"#{item.quantity}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_valor_#{i+1}\" value=\"#{self.to_money(item.price.to_s)}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_peso_#{i+1}\" value=\"#{self.to_weight(item.weight.to_s)}\" /> \n"      
    
      #TODO colocar o valor do frete.....
    end
    
    data += "<input type=\"submit\" /> \n"
    # data += "<script language=\"JavaScript\"> document.payment_form.submit(); </script> \n"

    data += "</form>"
    
  end


  #TODO Traduzir para ingles............
  # Formata o campo de decimal para String no padrao solicitado do PagSeguro
  # Ex.:
  # integracao.to_peso "0.5" ==> 500      #500 gramas
  # integracao.to_peso "0.50 ==> 500     #500 gramas
  # integracao.to_peso "0.05" ==> 050     #50 gramas
  # integracao.to_peso "0.005" ==> 005    #5 gramas
  # integracao.to_peso "1" ==> 1000       #1 kilo
  # integracao.to_peso "1.0" ==> 1000     #1 kilo
  #
  def to_weight valor    
    return nil if valor.nil?
    return nil if valor.class != String
    return "000" if valor.to_f == 0

    # obtem a parte fracionaria e transforma em string.
    frac = valor.to_f - valor.to_i
    frac = frac.to_s + "00"         
    frac = frac[2..4]
    inteiro = ""
    inteiro = valor.to_i.to_s if (valor.to_f.truncate > 0)
    novo_valor = inteiro + frac.to_s    
  end


  # TODO traduzir para ingles................
  # Formata o campo de decimal para String no padrao solicitado do PagSeguro
  # Ex.:
  # integracao.to_dinheiro "0.5" ==> 50      #50 centavos
  # integracao.to_dinheiro "0.50 ==> 50      #50 centavos
  # integracao.to_dinheiro "0.05" ==> 05     #5 centavos
  # integracao.to_dinheiro "1" ==> 100       #1 real
  # integracao.to_dinheiro "1.0" ==> 100     #1 real
  #
  def to_money valor
     return nil if valor.nil?
     return nil if valor.class != String
     return "00" if valor.to_f == 0

     # obtem a parte fracionaria e transforma em string.
     frac = valor.to_f - valor.to_i
     frac = frac.to_s + "0"         
     frac = frac[2..3]
     # Se tiver parte inteira, concatena com a parte fracionaria
     inteiro = ""
     inteiro = valor.to_i.to_s if valor.to_f.truncate > 0
     inteiro + frac
  end


  # # Envia um post para o PagSeguro solicitando a autenticidade do post enviado pelo PagSeguro
  # # Segundo a documentacao do PagSeguro, após o pagamento da compra, o sistema envia uma notificacao
  # # via post para o site do lojista.
  # # Este metodo é o responsavel por processar este post e conferir se os dados gravados na base de dados
  # # local está igual ao enviado pelo PagSeguro
  # # Caso tenha algo diferente retorna o Hash com a diferenca
  # #
  # # Ex.:
  # # PsIntegracao.compara_post_notificacao request, cliente, items ==> ['Nome' => 'valor_antigo > novo_valor']
  # def self.compara_post_notification request, ps_cliente, ps_items
  #   #TODO
  #   #TODO TEST
  # end
  # 
  # 
  # # Envia um post para o PagSeguro solicitando a autenticidade do post enviado pelo PagSeguro
  # # Segundo a documentacao do PagSeguro, após o pagamento da compra, o sistema envia uma notificacao
  # # via post para o site do lojista.
  # # Este metodo é o responsavel por enviar um novo post ao PS, solicitando a autenticidade do post recebido 
  # # informando o processamento da trasnacao, geramente a confirmacao de pagamento.
  # #
  # # Ex.:
  # # PsIntegracao.confirma_autenticidade cliente, items ==> ['FRAUDE', 'Alteracao do status da transacao fraudulenta!']
  # # PsIntegracao.confirma_autenticidade cliente, items ==> ['OK', 'Alteracao do status da transacao verificada!']  
  # #
  # def self.confirma_autenticidade ps_cliente, ps_items
  #   #TODO
  #   #TODO TEST
  # end



end
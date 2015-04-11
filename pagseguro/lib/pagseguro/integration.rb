require 'rubygems'
require 'uri'
require 'net/http'
require 'net/https'
require 'hpricot'
require "haml"

class Integration

  # Integration can be instantiated using a config file as parameter
  # if no one is specified, will be used the default: /../config/pageguro.yml
  #
  def initialize(pars = {})
    @config = YAML.load_file(
                (pars[:config].nil? ? File.dirname(__FILE__) + "/../../../../../../config/breshop.yml" : pars[:config]))["pagseguro"]

    @parametros_config = "tipo=#{@config['tipo_carrinho']}"
    @parametros_config << "&moeda=#{@config['moeda']}"
    @parametros_config << "&email_cobranca=#{@config['email_cobranca']}"

    @uri = URI.parse(@config['webpagto'])
  end

  # Create the form on HTML format to be posted into the PagSeguro website.
  # It requires HAML
  #
  # Ex.:
  # @form_html = integration.checkout sale ==> no shipment fee defined, will be calculated by PagSeguro
  #              if you define shipment_type (SD/EN) it will be used by PagSeguro, if not, the buyer will
  #              select one of then as shipment
  # @form_html = integration.checkout sale, "10.00" ==> fixed shipment fee
  #
  #TODO test
  def checkout sale, *frete

    raise "Invalid Sale" if sale.nil?
    raise "Invalid buyer! (nil)" if sale.buyer.nil?
    raise "Invalid buyer! (not a Buyer)" unless sale.buyer.class.eql? Buyer
    raise "Invalid Itens! (qt = 0)" if sale.itens.size == 0

    Haml::Engine.new(IO.readlines(File.dirname(__FILE__)+"/views/form.html.haml").join).render(Object.new,
      :config=>@config,
      :sale=>sale,
      :frete=>frete
    )

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
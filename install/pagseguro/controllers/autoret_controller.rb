class AutoretController < ApplicationController

  # ok 1 - token no arquivo de configuracao
  # 2 - install para copiar os arquivos apra dentro da aplicacao
  # ok 3 - testes
  # ok 4 - tela para mostrar os registros e excluir
  # ok 5 - post de confirmacao da mensagem
  # 6 - mostrar mensagem de texto apos a instalacao para executar o rake db:migrate

  def index
    @config = YAML.load_file(File.dirname(__FILE__) + "/../../config/breshop.yml")["pagseguro"]

    @params = Hash.new
    @params[:token] = @config['token']
    @params.merge!(request.parameters)

    Pstransaction.transaction do

      tx = Pstransaction.new
      tx.transaction_id = request.parameters["TransacaoID"]
      tx.seller_email = request.parameters["VendedorEmail"]
      tx.ref = request.parameters["Referencia"]
      tx.freight_type = request.parameters["TipoFrete"]
      tx.freight_value = request.parameters["ValorFrete"]
      tx.annotation = request.parameters["Anotacao"]
      tx.payment_type = request.parameters["TipoPagamento"]
      tx.status = request.parameters["StatusTransacao"]
      tx.cli_name = request.parameters["CliNome"]
      tx.cli_email = request.parameters["CliEmail"]
      tx.cli_address = request.parameters["CliEndereco"]
      tx.cli_number = request.parameters["CliNumero"]
      tx.cli_complement = request.parameters["CliComplemento"]
      tx.cli_district = request.parameters["CliBairro"]
      tx.cli_city = request.parameters["CliCidade"]
      tx.cli_state = request.parameters["CliEstado"]
      tx.cli_zip = request.parameters["CliCEP"]
      tx.cli_phone = request.parameters["CliTelefone"]
      tx.count_itens = request.parameters["NumItens"]

      1.upto(request.parameters["NumItens"].to_i)  do |c|
        product = Psproduct.new
        product.pstransaction = tx
        product.product_id = request.parameters["ProdID_#{c}"]
        product.description = request.parameters["ProdDescricao_#{c}"]
        product.price = request.parameters["ProdValor_#{c}"]
        product.quantity = request.parameters["ProdQuantidade_#{c}"]
        product.freight_value = request.parameters["ProdFrete_#{c}"]
        product.extra = request.parameters["ProdExtras_#{c}"]
        product.save
      end

      tx.save
    end

  end

  def show
    @txs = Pstransaction.find_by_id(params[:id]) unless params[:id].blank?
    @txs = Pstransaction.find(:all) if params[:id].blank?
  end

  def clean
    Pstransaction.delete_all
    Psproduct.delete_all
    redirect_to :action => 'show'
  end

end

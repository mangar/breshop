class Cliente
  attr_accessor :nome, :cep, :endereco, :numero, :complemento, :bairro, :cidade, :uf, :ddd, :telefone, :email

  def initialize(params = {})
    @nome = params[:nome]
    @cep = params[:cep]
    @endereco = params[:endereco]
    @numero = params[:numero]
    @complemento = params[:complemento]
    @bairro = params[:bairro]
    @cidade = params[:cidade]
    @uf = params[:uf]
    @ddd = params[:ddd]
    @telefone = params[:telefone]
    @email = params[:email]
  end
  
end
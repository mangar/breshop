# brEshop

**brEshop** é um *conjunto de bibliotecas* que pode ser utilizado para o desenvolvimento de uma loja virtual.

## Em desenvolvimento

Ainda estamos em processo de desenvolvimento. Você pode contribuir também!

Atualmente estamos desenvolvendo a integração com o serviço PagSeguro do UOL.

No entando o propósito desta biblioteca é integrar com vários outros serviços que facilitem o desenvolvimento e a integração de lojas virtuais com 
as mais diversas formas de pagamento existentes no Brasil.

Por enquanto o escopo do projeto é apenas o mercado brasileiro, ou seja, todas as formas de pagamento ou todos os mecanismos tediosos de serem desenvolvidos poderão ser incluídos neste plugin.
Caso você tenha alguma sugestão, e tenha tempo pode contribuir codificando (basta fazer um fork!), caso tenha alguma sugstão mas não tenha tempo de implementar, fique a vontade de entrar em contato.

## Testando

As configurações com o PagSeguro podem ser feitas em `pagseguro/lib/config/pagseguro.yml`

Para verificar o funcionamento comece pelo arquivo `pagseguro/lib/ps_integracao.rb` que é a classe principal da biblioteca PagSeguro.

Execute `rake test` para verificar se tudo está funcionando ok.

## Instalando

    ruby script/plugin install git://github.com/mangar/breshop.git

## Utilizando

	require 'breshop'

#### Consulta de Frete - PagSeguro

A consulta de frete feita através do PagSeguro pode ser executada a partir do comando:

    pedido = session[:pedido]
    pedido.cep1 = "14055"
    pedido.cep2 = "490"
    pedido.tipo_frete = "EN" #EN = PAC ou SD = Sedex

    pagseguro = PsIntegracao.new
    preco = pagseguro.calcular_frete pedido

    pedido.frete = preco

Maiores detalhes sobre a implementação, consulte o projeto: [breshop_demo_app][breshop_demo_app]

#### Checkout - PagSeguro

A ser implementado...


## Aviso

*Nada impede que estas bibliotecas sejam utilizadas em aplicativos comerciais ou de outra natureza que não **comércio eletrônico**.*


[breshop_demo_app]: http://github.com/mangar/breshop_demo_app/tree/master
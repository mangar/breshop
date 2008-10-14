14 de Outubro de 2008 (dookie)
==============================

	* Apoiado no modelo que o [Mangar](http://github.com/mangar/) desenvolveu, criei um modelo com mais classes para fazer a conexão com o [PagSeguro](https://pagseguro.uol.com.br/CarrinhoProprio.aspx).
	
	* Criei as classes:
  
  	Item
  	----
  	Apenas para conter dados de um item do carrinho. Criei para facilitar o desenvolvimento dos testes.

  	Items
  	-----
  	Um agrupamento de item, extendido de **Array**. Achei que seria mais fácil para gerenciar os items enviados ao PagSeguro.

  	Exceptions
  	----------
  	Como *Items* só poderia receber objetos do tipo *Item*, criei uma classe de **Exceptions** chamada *InvalidItem* para ser usada na classe Items.

  	Sales
  	-----
  	Classe que faz a conexão no PagSeguro. Inicialmente *faz apenas o cálculo do frete*. Melhor dizendo, carrega a página do PagSeguro e pega o valor do frete.

  	Pagseguro
  	---------
  	Faz a junção de todas as classes, para que sejam adicionandos items e o valor de frete seja retornado a partir do CEP de destino e do tipo de frete (**SD para Sedex** e **EN para Encomenda Normal**).

		* Criei arquivos de configuração na pasta config. Utilizei YAML, acreditando na facilidade de gerencialmento das configurações. Porém, haverá necessidade de modificar isso, pois as configurações são necessárias em mais classes, além da Pagseguro, que é a principal atualmente.

		* Criei testes para todas as classes, mas já notei que *faltou fazer validações nas classes*. **Precisamos criar validações para alguns dados.**
# brEshop

**brEshop** is a *library set* which can be used for e-commerce development.

## Working on

We are in development process. You can contribute too!

Currently, we are developing a integration with the service PagSeguro, provided by UOL.

## Testing

Execute `rake test` for check if everything is working fine.

## Disclaimer

*Nothing prevent this libraries are used in commercial applications or by other aim that not **e-commerce**.*

## Installing

To use brEshop plugin you have to have HAML installed:

	$ gem install --no-ri haml

And to install brEshop as plugin type: 

    ruby script/plugin install git://github.com/mangar/breshop.git

## Using

### PagSeguro - Checkout

	require 'breshop'
	#.
	#.
	#define os itens do carrinho de compras
	@item_1 = Item.new({:code=>"1",
	                        :description=>"produto01",
	                        :quantity=>1,
	                        :price=>11.50,
	                        :weight=>0.100})
 
	@item_2 = Item.new({:code=>"2",
	                        :description=>"producto02",
	                        :quantity=>2,
	                        :price=>22.30,
	                        :weight=>0.200})   
 
	#cria o carrinho de compras e insere os itens..
	sale = Sale.new
	sale << @item_1
	sale << @item_2
 
	#registra os dados do comprador.... e as ultimas opos de entrega...
	sale.buyer = Buyer.new
	sale.buyer.name = request.parameters['name'] + " " + request.parameters['last_name']
	sale.code = "TC01"
	sale.buyer.zip = request.parameters['zip1']+request.parameters['zip2']
	sale.buyer.address = request.parameters['address']
	sale.buyer.number = request.parameters['address_number']
	sale.buyer.complement = request.parameters['address_complement']
	sale.buyer.district = request.parameters['district']
	sale.buyer.city = request.parameters['city']
	sale.buyer.state = request.parameters['federal_unit']
	sale.buyer.email = request.parameters['email']
	sale.buyer.ext = request.parameters['phone1'][1..2]
	sale.buyer.phone = request.parameters['phone1'][4..12]
	sale.buyer.phone =     sale.buyer.phone.gsub('-', '')
	sale.shipment_type = sale.shipment_type
 
	pagseguro = Integration.new
	@content = pagseguro.checkout(sale)


### Calculating Freight (based on Correios website - http://correios.com.br)

	require 'breshop'
	#.
	#.
	correios = Correios.new
	preco = correios.freight sale.zip1+"-"+sale.zip2, sale.weight.to_s, sale.price.to_s


## Help

Do you wanna to help? Do you have any new idea? Contact us! Make a fork! 

Enjoy!

### Documentation

http://code.google.com/p/breshop






# brEshop

**brEshop** is a *library set* which can be used for e-commerce development.

## Working on

We are in development process. You can contribute too!

Currently, we are developing a integration with the service PagSeguro, provided by UOL.

## Testing

The configurations with the PagSeguro can be added in `pagseguro/config/test.yml`

For verify the operation you must begin in file `pagseguro/integration.rb` it is the main class of PagSeguro library.

Execute `rake test` for check if everything is working fine.

## Disclaimer

*Nothing prevent this libraries are used in commercial applications or by other aim that not **e-commerce**.*

## Installing

As plugin:

    ruby script/plugin install git://github.com/mangar/breshop.git

## Using

### PagSeguro

### Calculating Shipment

	require 'breshop'
	#.
	#.
  	def shipent_price

		# sale is your Sale object with products in
	    sale.zip1 = "04515"
	    sale.zip2 = "030"
	    sale.shipment_type = "SD" #SD or EN

	    pagseguro = Integration.new
	    price = pagseguro.shipment_price sale

		puts "Shipment price: #{price}"

  	end

### Checkout

*Soon..*


## Help

Do you wanna to help? Do you have any new idea? Contact us! Make a fork! 

Enjoy!

### Documentation

http://code.google.com/p/breshop






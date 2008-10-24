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
require 'fileutils'

puts "--------------------------------------------------------------------------------" 
puts " Welcome to brEshop plugin" 
puts "--------------------------------------------------------------------------------" 
 
puts "Copying 'breshop.yml'..."
breshop_yml_file = File.dirname(__FILE__) + '/../../../config/breshop.yml'
FileUtils.cp File.dirname(__FILE__) + '/install/breshop.yml', breshop_yml_file unless File.exist?(breshop_yml_file)


puts "Copying 'autoret_controller'...."
autoret_controller_file = File.dirname(__FILE__) + '/../../../app/controllers/autoret_controller.rb'
FileUtils.cp File.dirname(__FILE__) + '/install/pagseguro/controllers/autoret_controller.rb', autoret_controller_file unless File.exist?(autoret_controller_file)


puts "Copying views..."
rhtml_files = File.dirname(__FILE__) + '/../../../app/views/'
FileUtils.cp_r File.dirname(__FILE__) + '/install/pagseguro/views/autoret/', rhtml_files unless File.directory?(File.dirname(__FILE__) + '/../../../app/views/autoret/')


puts "Copying models...."
puts "  ... psproduct.rb ..."
model_files = File.dirname(__FILE__) + '/../../../app/models/psproduct.rb'
FileUtils.cp File.dirname(__FILE__) + '/install/pagseguro/models/psproduct.rb', model_files unless File.exist?(model_files)

puts "  ... pstransaction.rb ..."
model_files = File.dirname(__FILE__) + '/../../../app/models/pstransaction.rb'
FileUtils.cp File.dirname(__FILE__) + '/install/pagseguro/models/pstransaction.rb', model_files unless File.exist?(model_files)


puts "Copying migrations...."
puts "  ... create.pstransactions ..."
FileUtils.mkdir File.dirname(__FILE__) + '/../../../db/migrate/'

migrate_files = File.dirname(__FILE__) + '/../../../db/migrate/1_create_pstransactions.rb'
FileUtils.cp_r File.dirname(__FILE__) + '/install/pagseguro/db/migrate/1_create_pstransactions.rb', migrate_files unless File.exist?(migrate_files)

puts "  ... create.psproducts ..."
migrate_files = File.dirname(__FILE__) + '/../../../db/migrate/2_create_psproducts.rb'
FileUtils.cp_r File.dirname(__FILE__) + '/install/pagseguro/db/migrate/2_create_psproducts.rb', migrate_files unless File.exist?(migrate_files)


puts "Copying fixtures...."
puts "  ... psproduct.yml ..."
fixtures_files = File.dirname(__FILE__) + '/../../../test/fixtures/psproducts.yml'
FileUtils.cp File.dirname(__FILE__) + '/install/pagseguro/test/fixtures/psproducts.yml', fixtures_files unless File.exist?(fixtures_files)

puts "  ... pstransaction.yml ..."
fixtures_files = File.dirname(__FILE__) + '/../../../test/fixtures/pstransactions.yml'
FileUtils.cp File.dirname(__FILE__) + '/install/pagseguro/test/fixtures/pstransactions.yml', fixtures_files unless File.exist?(fixtures_files)


puts "Copying functional test...."
test_file = File.dirname(__FILE__) + '/../../../test/functional/autoret_controller_test.rb'
FileUtils.cp File.dirname(__FILE__) + '/install/pagseguro/test/functional/autoret_controller_test.rb', test_file unless File.exist?(test_file)

puts "\n\n\n\n"
puts "brEshop is almost done to be used, if you want to use it to just to integrate "
puts "with PagSeguro shopping cart or use it to calculate the freight it's done!"
puts ""
puts "Open the README.markdown file and take a look how to do that."
puts ""
puts "If you want to use the PagSeguro func: \"Automatic Return\" you are almost there, "
puts "just more one step:"
puts ""
puts "1 - Define a development and test database"
puts "2 - Run on command line: rake db:migrate"
puts ""
puts "These tasks will create two tables responsible to store posts comming from "
puts "PagSeguro: pstransactions and psproducts."
puts ""
puts "With your application running (./script/server), check the page: "
puts "http://localhost:3000/autoret/show it will shows you all records sent from PS."
puts "You can even simulate this communication pointing out your browser to:"
puts ""
puts "http://localhost:3000/autoret?VendedorEmail=emaildovendedor&TransacaoID=123&Referencia=referencia&TipoFrete=FR&ValorFrete=10,00&Anotacao=anotacaooo&DataTransacao=dd/mm/yyyy hh:mm:ss&TipoPagamento=Pagamento via cartão de crédito&StatusTransacao=Em Análise&CliNome=NomeDoCabra&CliEmail=email@uol.com.br&CliEndereco=Endereco do cliente&CliNumero=1741&CliComplemento=AP22&CliBairro=Moema&CliCidade=Sao Paulo&CliEstado=SP&CliCEP=14055490&CliTelefone=00 00000000&NumItens=1&ProdID_1=1&ProdDescricao_1=Nome do Produto 01&ProdValor_1=100,00&ProdQuantidade_1=2&ProdFrete_1=10&ProdExtras_1=0"
puts ""
puts "More info about Automatic Return service can be found in PagSeguro website, in "
puts "functional test suite, and even talking with brEshop developers."
puts ""












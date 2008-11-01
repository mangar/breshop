PROJECTS = %w(general pagseguro correios)

PROJECTS.each do |project|
  require "#{File.dirname(__FILE__)}/#{project}/rails/init"
end

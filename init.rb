PROJECTS = %w(general pagseguro)

PROJECTS.each do |project|
  require "#{File.dirname(__FILE__)}/#{project}/rails/init"
end

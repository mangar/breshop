PROJECTS = %w(general pagseguro)

PROJECTS.each do |project|
  require project
end

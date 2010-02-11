
base = File.join(File.dirname(__FILE__), 'core')

Dir[File.join(base, "/*.rb")].each do |f|
  name = File.basename(f, '.rb')

  autoload name.camelize.intern, File.join(base, name)

end


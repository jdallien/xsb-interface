Gem::Specification.new do |s|
  s.name = %q{xsb-interface}
  s.version = "0.0.3"
  s.date = Time.now
  s.summary = %q{An interface to XSB, as a gem.}
  s.email = %q{jdallien@mdlogix.com}
  s.homepage = %q{http://www.mdlogix.com}
  s.platform = Gem::Platform::RUBY
  s.require_paths << "lib"
  s.require_paths << "ext"
  s.authors = ["Medical Decision Logic"]
  s.files = 
    [
      "lib/xsb.rb",
      "lib/conn_pool.rb",
      "ext/xsbinterface/xsbinterface.c",
      "ext/xsbinterface/extconf.rb",
      "ext/xsbinterface/configure.in",
      "ext/xsbinterface/Makefile.in",
      "tests/xsb_test.rb"
    ]
  s.has_rdoc = true
  s.extensions = ["ext/xsbinterface/extconf.rb"]
  s.test_file = 'tests/xsb_test.rb'
  s.rdoc_options << '--line-numbers' << '-Y' << 'lib/xsb.rb'
end

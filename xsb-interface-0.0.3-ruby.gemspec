# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{xsb-interface}
  s.version = "0.0.3"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Medical Decision Logic"]
  s.cert_chain = nil
  s.date = %q{2008-11-21}
  s.email = %q{jdallien@mdlogix.com}
  s.extensions = ["ext/xsbinterface/extconf.rb"]
  s.files = ["lib/xsb.rb", "lib/conn_pool.rb", "ext/xsbinterface/xsbinterface.c", "ext/xsbinterface/extconf.rb", "ext/xsbinterface/configure.in", "ext/xsbinterface/Makefile.in", "tests/xsb_test.rb", "Rakefile"]
  s.has_rdoc = true
  s.homepage = %q{http://www.mdlogix.com}
  s.rdoc_options = ["--line-numbers", "-Y", "lib/xsb.rb"]
  s.require_paths = ["lib", "lib", "ext"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An interface to XSB, as a gem.}
  s.test_files = ["tests/xsb_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

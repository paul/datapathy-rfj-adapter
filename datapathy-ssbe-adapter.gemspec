# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{datapathy-ssbe-adapter}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Sadauskas"]
  s.date = %q{2009-09-24}
  s.email = %q{psadauskas@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/datapathy-ssbe-adapter.rb",
     "lib/resource_descriptor.rb",
     "lib/service_descriptor.rb",
     "lib/ssbe_authenticator.rb",
     "lib/ssbe_model.rb",
     "spec/datapathy-ssbe-adapter_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/paul/datapathy-ssbe-adapter}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{TODO}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/datapathy-ssbe-adapter_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

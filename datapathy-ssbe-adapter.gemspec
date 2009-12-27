# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{datapathy-ssbe-adapter}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Sadauskas"]
  s.date = %q{2009-12-26}
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
     "datapathy-ssbe-adapter.gemspec",
     "lib/datapathy-ssbe-adapter.rb",
     "lib/datapathy-ssbe-adapter/access_control.rb",
     "lib/datapathy-ssbe-adapter/models/resource_descriptor.rb",
     "lib/datapathy-ssbe-adapter/models/service_descriptor.rb",
     "lib/datapathy-ssbe-adapter/ssbe_model.rb",
     "lib/resourceful/ssbe_authenticator.rb",
     "spec/create_spec.rb",
     "spec/read_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/support/models.rb"
  ]
  s.homepage = %q{http://github.com/paul/datapathy-ssbe-adapter}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Datapath adapter for ssbe web services}
  s.test_files = [
    "spec/read_spec.rb",
     "spec/spec_helper.rb",
     "spec/support/models.rb",
     "spec/create_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<resourceful>, [">= 0"])
      s.add_runtime_dependency(%q<datapathy>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<httpauth>, [">= 0"])
    else
      s.add_dependency(%q<resourceful>, [">= 0"])
      s.add_dependency(%q<datapathy>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<httpauth>, [">= 0"])
    end
  else
    s.add_dependency(%q<resourceful>, [">= 0"])
    s.add_dependency(%q<datapathy>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<httpauth>, [">= 0"])
  end
end


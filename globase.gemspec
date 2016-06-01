$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "globase/version"

Gem::Specification.new do |s|
  s.name = "globase"
  s.version =  Globase::VERSION
  s.authors = ["Robin Wunderlin"]
  s.email = "robin@wunderlin.dk"
  s.homepage = "http://www.rhg.dk"
  s.summary = "Interface to the Globase API"
  s.description = "Interface to the Globase API"

  s.files = Dir["[A-Z]*", "{app,config,db,public,lib,generators}/**/*"]+ ["LICENSE", "Rakefile", "README.markdown"]
  s.extra_rdoc_files = [
    "README.markdown"
  ]

  s.required_ruby_version = '>= 2.1.9'
  s.require_paths = ["lib"]

  # s.date = "#{Time.now.to_date}"
  s.post_install_message = File.open('USAGE').read

  s.add_runtime_dependency(%q<rest-client>, [">= 0"])
  s.add_runtime_dependency(%q<activesupport>, [">= 0"])

  s.add_runtime_dependency(%q<oj>, [">= 2.14.0"])
  s.add_runtime_dependency(%q<oj_mimic_json>, [">= 0"])

end


# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chance/version"

Gem::Specification.new do |s|
  s.name        = "chance"
  s.version     = Chance::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Graeme Collins"]
  s.email       = ["graeme.collins.0@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A dice rolling mechanism that supports basic dice notation}
  s.description = %q{Generate random numbers using dice notation}

  s.rubyforge_project = "chance"
  s.add_development_dependency "shoulda"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

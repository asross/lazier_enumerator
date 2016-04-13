$:.push File.expand_path("../lib", __FILE__)

require 'lazier_enumerator/version'

Gem::Specification.new do |s|
  s.name        = 'lazier_enumerator'
  s.version     = LazierEnumerator::VERSION
  s.authors     = ["Andrew Ross"]
  s.email       = ["andrewslavinross@gmail.com"]
  s.homepage    = "http://github.com/asross/lazier_enumerator"
  s.summary     = "Lazy helpers for compact, uniq, and flatten"
  s.description = ""
  s.license     = "MIT"
end

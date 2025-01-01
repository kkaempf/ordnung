require_relative 'lib/ordnung/version'

Gem::Specification.new do |s|
  s.name                    = "ordnung"
  s.version                 = Ordnung::VERSION
  s.date                    = Time.now.strftime("%Y-%m-%d")
  s.summary                 = "Ordnung library"
  s.description             = "Keep all your data organized"
  s.authors                 = ["Klaus Kämpf"]
  s.email                   = "kkaempf@gmail.com"
  s.files                   = `git ls-files`.split("\n")
  s.executables             = ["import", "duplicates", "list"]
  s.bindir                  = "bin"
  s.require_paths           = ["lib"]
  s.homepage                = "http://github.com/kkaempf/Ordnung"
  s.license                 = "MIT"
  s.add_runtime_dependency("exifr", "~> 1.3")
  s.add_runtime_dependency("gif-info", "~> 0.1.1")
  s.add_runtime_dependency("json", "~> 2.6")
  s.add_runtime_dependency("opensearch-ruby", "~> 3.4")
  s.add_runtime_dependency("optimist", "~> 3.0")
  s.add_development_dependency("rspec")
end

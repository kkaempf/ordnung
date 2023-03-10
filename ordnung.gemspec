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
  s.executables             = ["import", "duplicates"]
  s.bindir                  = "bin"
  s.require_paths           = ["lib"]
  s.homepage                = "http://github.com/kkaempf/Ordnung"
  s.license                 = "MIT"
  s.add_runtime_dependency("optimist")
  s.add_runtime_dependency("json")
  s.add_runtime_dependency("arangodb-driver", "~> 3.10")
  s.add_development_dependency("rspec")
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_importer/version'

Gem::Specification.new do |spec|
  spec.name          = "csv_importer"
  spec.version       = CsvImporter::VERSION
  spec.date          = Time.now.strftime("%F")
  spec.authors       = ["Mehdi FARSI"]
  spec.email         = ["mehdifarsi.pro@gmail.com"]

  spec.summary       = "An idempotent CSV-to-DB importer"
  spec.homepage      = "https://github.com/mehdi-farsi/csv_importer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rails", "4.2.6"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end

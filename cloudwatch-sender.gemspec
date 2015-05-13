# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudwatch/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudwatch-sender"
  spec.version       = CloudwatchSender::VERSION
  spec.authors       = ["DaveBlooman"]
  spec.email         = ["david.blooman@gmail.com"]
  spec.summary       = "Cloudwatch Metrics Sender"
  spec.description   = "Get metrics from Cloudwatch and send to Graphite/InfluxDB"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "aws-sdk"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "logger"
end

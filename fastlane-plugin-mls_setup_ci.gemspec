lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/mls_setup_ci/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-mls_setup_ci'
  spec.version       = Fastlane::MlsSetupCi::VERSION
  spec.author        = 'MyLittleSuite'
  spec.email         = 'info@mylittlesuite.com'

  spec.summary       = 'MyLittleSuite Setup CI'
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-mls_setup_ci"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fastlane', '>= 2.193.0')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.12.1')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
end

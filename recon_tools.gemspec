# frozen_string_literal: true

require File.expand_path('lib/recon_tools/version', __dir__)

Gem::Specification.new do |spec|
  spec.name                  = 'recon_tools'
  spec.version               = ReconTool::VERSION
  spec.authors               = ['Chris Rowe']
  spec.email                 = ['coder-chris-github@gmail.com']
  spec.summary               = 'recon_tools: Tools to support importing, exporting and reconciliation of data'
  spec.description           = 'recon_tools: Tools to support importing, exporting and reconciliation of data from JIRA, GoogleSheets and more..'
  spec.homepage              = 'https://github.com/coder-chris/recon_tools'
  spec.license               = 'MIT'
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.5.0'

  spec.files = Dir['README.md', 'LICENSE',
                   'CHANGELOG.md', 'lib/**/*.rb',
                   'lib/**/*.rake',
                   'recon_tools.gemspec', '.github/*.md',
                   'Gemfile', 'Rakefile']
  spec.test_files       = Dir['spec/**/*.rb']
  spec.extra_rdoc_files = ['README.md']
  spec.require_paths    = ['lib']

  #spec.add_dependency 'rubyzip', '~> 2.3'

  #spec.add_development_dependency 'dotenv', '~> 2.5'
  if ENV['TEST_RAILS_VERSION'].nil?
    spec.add_development_dependency 'rails', '~> 6.1.4'
  else
    spec.add_development_dependency 'rails', ENV['TEST_RAILS_VERSION'].to_s
  end

  spec.add_dependency 'google_drive'
  spec.add_dependency 'logging'

  spec.add_dependency 'google'
  spec.add_dependency 'google_docs'
  spec.add_dependency 'json'
  spec.add_dependency 'minitest'
  spec.add_dependency 'test'

  spec.add_dependency 'net'
  spec.add_dependency 'uri'
  spec.add_dependency 'date'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 1.25'
  spec.add_development_dependency 'rubocop-performance', '~> 1.13'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.8.0'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'asciidoctor'
  spec.add_development_dependency 'asciidoctor-diagram'
end

# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.1'
  spec.name        = 'perilune'
  spec.version     = '0.0.1'
  spec.authors     = ['Kartavya Pareek', 'Jozef Vaclavik']
  spec.email       = ['hi@dropbot.sh']
  spec.summary     = 'Summary of Perilune.'
  spec.description = 'Description of Perilune.'
  spec.homepage    = 'https://engineering.dropbot.sh'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/sandbite/perilune'
  spec.metadata['changelog_uri'] = 'https://github.com/sandbite/perilune/blob/main/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']

  spec.add_dependency 'ledger_sync-domains', '~> 1.1.1'
  spec.add_dependency 'rails', '~> 7.0.0', '>= 7.0.0.0'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rspec-rails'
  spec.add_dependency 'trifle-logger'
end

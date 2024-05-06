# frozen_string_literal: true

require_relative 'lib/perilune/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.7'
  spec.name        = 'perilune'
  spec.version     = Perilune::VERSION
  spec.authors     = ['Kartavya Pareek', 'Jozef Vaclavik']
  spec.email       = ['hi@dropbot.sh']
  spec.summary     = 'Add Imports and Exports to your app with ease.'
  spec.description = 'Perilune is a Rails Engine that allows you to define Task classes for'\
                     'procesing files and handles their processing on the background for you.'
  spec.homepage    = 'https://dropbot.sh'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/sandbite/perilune'
  spec.metadata['changelog_uri'] = 'https://github.com/sandbite/perilune/blob/main/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']

  spec.add_dependency 'factory_bot_rails'
  spec.add_dependency 'ledger_sync-domains', '~> 1.2'
  spec.add_dependency 'rails', '~> 7.0', '>= 7.0.0.0'
  spec.add_dependency 'trifle-stats', '~> 1.3'
  spec.add_dependency 'trifle-traces', '~> 1.1'
  spec.add_development_dependency 'database_cleaner-active_record'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'timecop'
end

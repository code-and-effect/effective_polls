$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'effective_polls/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'effective_polls'
  spec.version     = EffectivePolls::VERSION
  spec.authors     = ['Code and Effect']
  spec.email       = ['info@codeandeffect.com']
  spec.homepage    = 'https://github.com/code-and-effect/effective_polls'
  spec.summary     = 'Online polls and user voting.'
  spec.description = 'Online polls and user voting.'
  spec.license     = 'MIT'

  spec.files = Dir["{app,config,db,lib}/**/*"] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 6.0.0'
  spec.add_dependency 'effective_bootstrap'
  spec.add_dependency 'effective_datatables', '>= 4.0.0'
  spec.add_dependency 'effective_email_templates'
  spec.add_dependency 'effective_resources'
  spec.add_dependency 'wicked'
  spec.add_dependency 'sassc'

  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'devise'
  spec.add_development_dependency 'haml'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'effective_test_bot'
  spec.add_development_dependency 'effective_developer' # Optional but suggested
  spec.add_development_dependency 'psych', '< 4'
end

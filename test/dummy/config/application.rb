require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

require 'haml'
require 'devise'
require 'wicked'
require 'effective_email_templates'
require 'effective_test_bot'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

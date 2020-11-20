module EffectivePolls
  class Engine < ::Rails::Engine
    engine_name 'effective_polls'

    # Set up our default configuration options.
    initializer 'effective_polls.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_polls.rb")
    end

  end
end

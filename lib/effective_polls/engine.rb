module EffectivePolls
  class Engine < ::Rails::Engine
    engine_name 'effective_polls'

    # Set up our default configuration options.
    initializer 'effective_polls.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_polls.rb")
    end

    # Include effective_polls_user concern and allow any ActiveRecord object to call it
    initializer 'effective_polls.active_record' do |app|
      app.config.to_prepare do
        ActiveRecord::Base.extend(EffectivePollsUser::Base)
      end
    end

  end
end

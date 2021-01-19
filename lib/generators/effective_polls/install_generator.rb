module EffectivePolls
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Creates an EffectivePolls initializer in your application.'

      source_root File.expand_path('../../templates', __FILE__)

      def self.next_migration_number(dirname)
        if not ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          '%.3d' % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializer
        template ('../' * 3) + 'config/effective_polls.rb', 'config/initializers/effective_polls.rb'
      end

      def create_migration_file
        @polls_table_name = ':' + EffectivePolls.polls_table_name.to_s
        @poll_questions_table_name = ':' + EffectivePolls.poll_questions_table_name.to_s
        @poll_notifications_table_name = ':' + EffectivePolls.poll_notifications_table_name.to_s
        @poll_question_options_table_name = ':' + EffectivePolls.poll_question_options_table_name.to_s
        @ballots_table_name = ':' + EffectivePolls.ballots_table_name.to_s
        @ballot_responses_table_name  = ':' + EffectivePolls.ballot_responses_table_name.to_s
        @ballot_response_options_table_name  = ':' + EffectivePolls.ballot_responses_table_name.to_s

        migration_template ('../' * 3) + 'db/migrate/01_create_effective_polls.rb.erb', 'db/migrate/create_effective_polls.rb'
      end

    end
  end
end

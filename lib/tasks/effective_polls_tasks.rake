# rake effective_polls:send_notifications

namespace :effective_polls do
  desc 'Send email notifications for effective polls'
  task send_notifications: :environment do
    puts 'Sending notifications'

    table = ActiveRecord::Base.connection.table_exists?(:poll_notifications)
    blank_tenant = defined?(Tenant) && Tenant.current.blank?

    if table && !blank_tenant
      poll_notifications = Effective::PollNotification.deep.notifiable

      poll_notifications.find_each do |notification|
        begin
          notified = notification.notify!
          puts "Sent #{notification.category} for #{notification.poll}" if notified
        rescue StandardError => e
          data = { poll_notification_id: notification.id, poll_id: notification.poll_id }
          ExceptionNotifier.notify_exception(e, data: data) if defined?(ExceptionNotifier)
          puts "Error with effective poll_notification #{notification.id}: #{e.errors.inspect}"
        end
      end
    end

    puts 'All done'
  end

  # Deprecated version
  task notify: :environment do
    Rake::Task['effective_polls:send_notifications'].invoke
  end

end

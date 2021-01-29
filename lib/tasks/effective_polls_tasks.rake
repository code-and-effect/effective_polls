# rake effective_polls:notify

namespace :effective_polls do
  desc 'Send email notifications for effective polls'
  task notify: :environment do
    poll_notifications = Effective::PollNotification.all.deep.notifiable

    poll_notifications.find_each do |notification|
      begin
        notified = notification.notify!
        puts "Sent #{notification.category} for #{notification.poll}" if notified
      rescue => e
        if defined?(ExceptionNotifier)
          ExceptionNotifier.notify_exception(e, data: { poll_notification_id: notification.id, poll_id: notification.poll_id })
        end

        puts "Error with effective poll_notification #{notification.id}: #{e.errors.inspect}"
      end
    end

    puts 'All done'
  end
end

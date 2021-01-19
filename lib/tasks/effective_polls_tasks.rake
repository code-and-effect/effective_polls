# rake effective_polls:notify

namespace :effective_polls do
  desc 'Send email notifications for effective polls'
  task notify: :environment do
    poll_notifications = Effective::PollNotification.all.deep.notifiable

    poll_notifications.find_each do |poll_notification|
      begin
        notified = poll_notification.notify!
        puts "Sent #{poll_notification.category} for #{poll_notification.poll}" if notified
      rescue => e
        if defined?(ExceptionNotifier)
          data = { poll_notification_id: poll_notification.id, poll_id: poll_notification.poll_id }
          ExceptionNotifier.notify_exception(e, data: data)
        end

        puts "Error with effective poll_notification #{poll_notification.id}: #{e.errors.inspect}"
      end
    end

    puts 'All done'
  end
end

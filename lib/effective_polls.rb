require 'effective_datatables'
require 'effective_resources'
require 'effective_polls/engine'
require 'effective_polls/version'

module EffectivePolls
  mattr_accessor :polls_table_name

  mattr_accessor :authorization_method
  mattr_accessor :permitted_params

  mattr_accessor :layout

  mattr_accessor :use_active_storage

  def self.setup
    yield self
  end

  def self.authorized?(controller, action, resource)
    @_exceptions ||= [Effective::AccessDenied, (CanCan::AccessDenied if defined?(CanCan)), (Pundit::NotAuthorizedError if defined?(Pundit))].compact

    return !!authorization_method unless authorization_method.respond_to?(:call)
    controller = controller.controller if controller.respond_to?(:controller)

    begin
      !!(controller || self).instance_exec((controller || self), action, resource, &authorization_method)
    rescue *@_exceptions
      false
    end
  end

  def self.authorize!(controller, action, resource)
    raise Effective::AccessDenied.new('Access Denied', action, resource) unless authorized?(controller, action, resource)
  end

  def self.permitted_params
    raise('todo')
  end

end

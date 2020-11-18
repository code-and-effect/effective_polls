# Effective Polls

Online polls and user voting.

An admin creates polls with one or more poll_questions. The poll can be assigned to users through a poll_ballot.

The user can complete the poll_ballot and anonymously vote for each option.

Some reports to display results.

## Getting Started

Please first install the [effective_datatables](https://github.com/code-and-effect/effective_datatables) gem.

Please download and install [Twitter Bootstrap4](http://getbootstrap.com)

Add to your Gemfile:

```ruby
gem 'effective_polls'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_polls:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table name (to use something other than the default 'polls'), manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

## Polls

TODO

## Authorization

All authorization checks are handled via the config.authorization_method found in the `app/config/initializers/effective_polls.rb` file.

It is intended for flow through to CanCan or Pundit, but neither of those gems are required.

This method is called by all controller actions with the appropriate action and resource

Action will be one of [:index, :show, :new, :create, :edit, :update, :destroy]

Resource will the appropriate Effective::Poll object or class

The authorization method is defined in the initializer file:

```ruby
# As a Proc (with CanCan)
config.authorization_method = Proc.new { |controller, action, resource| authorize!(action, resource) }
```

```ruby
# As a Custom Method
config.authorization_method = :my_authorization_method
```

and then in your application_controller.rb:

```ruby
def my_authorization_method(action, resource)
  current_user.is?(:admin) || EffectivePunditPolicy.new(current_user, resource).send('#{action}?')
end
```

or disabled entirely:

```ruby
config.authorization_method = false
```

If the method or proc returns false (user is not authorized) an Effective::AccessDenied exception will be raised

You can rescue from this exception by adding the following to your application_controller.rb:

```ruby
rescue_from Effective::AccessDenied do |exception|
  respond_to do |format|
    format.html { render 'static_pages/access_denied', status: 403 }
    format.any { render text: 'Access Denied', status: 403 }
  end
end
```

### Permissions

The permissions you actually want to define are as follows (using CanCan):

```ruby
can [:index, :show], Effective::Poll

if user.admin?
  can :manage, Effective::Poll
  can :admin, :effective_polls
end
```

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Testing

Run tests by:

```ruby
rails test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request

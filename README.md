# git-profile

**git-profile** is a CLI tool which allows you to switch between multiple git profiles interactively.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-profile'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install git-profile

## Usage

`$ git-profile <command>`

Commands:
```
  git-profile add                # Adds a new git profile
  git-profile delete [username]  # Remove a specific git profile
  git-profile help [COMMAND]     # Describe available commands or one specific command
  git-profile list               # List all available git profiles.
  git-profile reset              # Deletes all data and reset.
  git-profile use [username]     # Set the global git profile.
  git-profile whoami             # Show the global git profile
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/git-profile.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

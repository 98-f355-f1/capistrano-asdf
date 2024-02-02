# Capistrano::asdf

ASDF support for Capistrano v3:

## Notes

**If you use this integration with capistrano-rails, please ensure that you have `capistrano-bundler >= 1.1.0`.**

If you want solution with asdf/rubies installer included, give a try to [asdf1-capistrano3](https://github.com/asdf/asdf1-capistrano3).

## Installation

Add this line to your application's Gemfile:

    # Gemfile
    gem 'capistrano', '~> 3.0'
    gem 'capistrano-asdf'

And then execute:

    $ bundle install

## Usage

Require in Capfile to use the default task:

    # Capfile
    require 'capistrano/asdf'

And you should be good to go!

## Configuration

Everything *should work* for a basic asdf setup *out of the box*.

If you need some special settings, set those in the stage file for your server:

    # deploy.rb or stage file (staging.rb, production.rb or else)
    set :asdf_type, :user                     # Defaults to: :auto
    set :asdf_ruby_version, '2.0.0-p247'      # Defaults to: 'default'
    set :asdf_custom_path, '~/.myveryownasdf'  # only needed if not detected

### asdf path selection: `:asdf_type`

Valid options are:
  * `:auto` (default): just tries to find the correct path.
                       `~/.asdf` wins over `/usr/local/asdf`
  * `:system`: defines the asdf path to `/usr/local/asdf`
  * `:user`: defines the asdf path to `~/.asdf`

### Ruby and gemset selection: `:asdf_ruby_version`

By default the Ruby and gemset is used which is returned by `asdf current` on
the target host.

You can omit the ruby patch level from `:asdf_ruby_version` if you want, and
capistrano will choose the most recent patch level for that version of ruby:

    set :asdf_ruby_version, '2.0.0'

If you are using an asdf gemset, just specify it after your ruby_version:

    set :asdf_ruby_version, '2.0.0-p247@mygemset'

or

    set :asdf_ruby_version, '2.0.0@mygemset'

### Custom asdf path: `:asdf_custom_path`

If you have a custom asdf setup with a different path then expected, you have
to define a custom asdf path to tell capistrano where it is.

### Custom Roles: `:asdf_roles`

If you want to restrict asdf usage to a subset of roles, you may set `:asdf_roles`:

    set :asdf_roles, [:app, :web]

## Restrictions

Capistrano can't use asdf to install rubies or create gemsets, so on the
servers you are deploying to, you will have to manually use asdf to install the
proper ruby and create the gemset.


## How it works

This gem adds a new task `asdf:hook` before `deploy` task.
It sets the `asdf ... do ...` for capistrano when it wants to run
`rake`, `gem`, `bundle`, or `ruby`.


## Check your configuration

If you want to check your configuration you can use the `asdf:check` task to
get information about the asdf version and ruby which would be used for
deployment.

    $ cap production asdf:check

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

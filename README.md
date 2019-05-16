[![Gem Version](https://badge.fury.io/rb/mina-proteus.svg)](https://badge.fury.io/rb/mina-proteus)

# Mina::Proteus

Plugin for Mina that adds support for multiple stages and multiple apps to Mina, specifically built for Hanami ruby framework.
This gem is based on [endoze's mina-multistage gem](https://github.com/endoze/mina-multistage), huge thanks to him!

## Installation & Usage

Add this line to your application's Gemfile:

```rb
gem 'mina-proteus', require: false
```

And then execute:

```shell
$ bundle install
```

Or install it yourself as:

```shell
$ gem install mina-proteus
```

Require `mina/proteus` in your `config/deploy.rb`:

```rb
# config/deploy.rb

require 'mina/proteus'
require 'mina/bundler'
require 'mina/git'

...

task setup: do
  ...
end

desc 'Deploys the current version to the server.'
task deploy:  do
  ...
end
```
You then need to specify your hanami apps like this:

```rb
# config/deploy.rb

set :hanami_apps, %w(app1 app2 app3)
```

That's the only required parameter, optional parameters are:

```rb
# config/deploy.rb

set :stages, %w(staging production)   #specify your stages
set :stages_dir, 'config/deploy'      #specify which directory will have all the configurations files
set :default_stage, 'staging'         #specify your default stage

#this is used to deploy a single application in a specific environment
set :bundle_prefix, -> { %{HANAMI_ENV="#{fetch(:current_stage)}" HANAMI_APPS="#{fetch(:current_app)}" #{fetch(:bundle_bin)} exec} }
```

Then to create every file run:

```shell
$ bundle exec mina proteus:init
```

This will create `config/deploy/staging.rb` and `config/deploy/production.rb` stage files and 
`config/deploy/staging/app1.rb`, `config/deploy/staging/app1.rb`, etc. 
Use them to define stage and app specific configuration.

Now you can deploy the default stage with:

```shell
$ mina <APP-NAME> deploy # this deploys to :default_stage
```

Or specify a stage explicitly:

```shell
$ mina staging <APP-NAME> deploy
$ mina production <APP-NAME> deploy
```

## Maintenance
I'll be rarely maintaining this gem due to lack of time, if you want to contibute feel free to fork it, branch it and then create a pull request
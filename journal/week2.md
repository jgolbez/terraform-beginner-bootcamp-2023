# Terraform Beginner Bootcamp 2023 - Week 2

## Working With Ruby


### Bundler
Bundler is a package manager for Ruby and is the primary way to install Ruby packages known as Gems for Ruby

#### Install Gems
Create a Gemfile and define gems in that file

```rb
source "https://rubygems.org"
gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```
Then run `bundle install` command to install gems on system globally
A Gemfile.lock will be created to lock version of gems used for this project

#### Executing Ruby scripts in context of Bundler
Use `bundle exec` to tell Ruby scripts to use the gems installed to set context

### Sinatra
Micro-Web framework for Riby to build web apps for mock/dev servers or very simple projects
Create web server in single file

[Sinatra Web](https://sinatrarb.com)

## TerraTowns Mock Web Server

### Running Web Server

Run web server by executing commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for the server is in server.rb file





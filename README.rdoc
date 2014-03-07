# Bender

[![Build Status](https://travis-ci.org/collectiveidea/bender.png?branch=master)](https://travis-ci.org/collectiveidea/bender)
[![Code Climate](https://codeclimate.com/github/collectiveidea/bender.png)](https://codeclimate.com/github/collectiveidea/bender)
[![Test Coverage](https://codeclimate.com/github/collectiveidea/coverage.png)](https://codeclimate.com/github/collectiveidea/feed)

A kegerator monitoring application.

[![Home page]](http://i.imgur.com/wBebZEB.png)

[![Keg details page]](http://i.imgur.com/oMi5kKF.png)

## Running

### Requirements

* Ruby 2.1.1
* PostgreSQL

### Setup

1. Clone the repo
2. `bundle`
3. `cp config/settings.yml{.example,}` and modify if needed
4. `cp config/database.yml{.example,}` and modify if needed
5. `rake db:setup`
6. `rails server`

## Contributing

1. Clone repository. `git clone git@github.com:collectiveidea/localorbit.git`
2. Create a branch for your feature. `git checkout -b my-awesome-feature-name master`
3. Make changes and commit.
4. Run the tests. `rake`
5. Push to remote branch. `git push origin my-awesome-feature-name`
6. Create a Pull Request. Visit `https://github.com/collectiveidea/localorbit/compare/master...my-awesome-feature-name`

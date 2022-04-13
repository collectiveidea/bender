# Bender

[![CI](https://github.com/collectiveidea/bender/actions/workflows/ci.yml/badge.svg)](https://github.com/collectiveidea/bender/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/collectiveidea/bender.png)](https://codeclimate.com/github/collectiveidea/bender)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

A kegerator monitoring application built to run on a RaspberryPi or BeagleBone Black.

![Home page](http://i.imgur.com/wBebZEB.png)

![Keg details page](http://i.imgur.com/oMi5kKF.png)

## Running

### Requirements

* Ruby 3.1.1
* PostgreSQL
* Foreman (`gem install foreman`) or another Procfile runner

### Setup

1. Clone the repo
2. `bundle`
3. `bin/setup`
6. `foreman start -f Procfile.dev`

## Contributing

1. Clone repository. `git clone git@github.com:collectiveidea/bender.git`
2. Create a branch for your feature. `git checkout -b my-awesome-feature-name master`
3. Make changes and commit.
4. Run the tests. `rake`
5. Push to remote branch. `git push origin my-awesome-feature-name`
6. Create a Pull Request.
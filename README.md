# Bender

[![CI](https://github.com/collectiveidea/bender/actions/workflows/ci.yml/badge.svg)](https://github.com/collectiveidea/bender/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/collectiveidea/bender.png)](https://codeclimate.com/github/collectiveidea/bender)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

A kegerator monitoring application built to run on a RaspberryPi or BeagleBone Black.

Currently runs at Collective Idea on a Raspberry Pi 4. Previously it ran on a Pi 3 (see ruby2 tag). It is both simplistic and overkill at the same time. Why not?

![Home page](http://i.imgur.com/wBebZEB.png)

![Keg details page](http://i.imgur.com/oMi5kKF.png)

## Running

### Requirements

* Ruby 3.1.1
* PostgreSQL
* Foreman (`gem install foreman`) or another Procfile runner (Overmind)

### Setup

1. Clone the repo
2. `bundle`
3. `bin/setup`
6. `foreman start -f Procfile.dev`

### Production

See `doc/pi_setup.md` for current instructions.

## Basic concepts

The Rails app is pretty typical. There's a Faye process (running via Rack) to facilitate some realtime data updates.

Many settings are controlled by environment variables. See the `.env.example` and copy to `.env` as needed.

Pours and taps are controlled via the Pi's GPIO. Two rake tasks manage them. The pour monitoring runs a separate `mruby` process.

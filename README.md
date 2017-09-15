# Bender

[![Build Status](https://travis-ci.org/collectiveidea/bender.png?branch=master)](https://travis-ci.org/collectiveidea/bender)
[![Code Climate](https://codeclimate.com/github/collectiveidea/bender.png)](https://codeclimate.com/github/collectiveidea/bender)

A kegerator monitoring application built to run on a RaspberryPi or BeagleBone Black.

![Home page](http://i.imgur.com/wBebZEB.png)

![Keg details page](http://i.imgur.com/oMi5kKF.png)

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

## Hardware

![Raspberry Pi 3](http://www.mcmelectronics.com/product/83-17300)

Flow sensing
![Swissflow SF800](http://www.swissflow.com/sf800.html)
![John Guest Fitting, 3/8" Stem OD x 1/4" Hose ID (Pack of 10)](https://www.amazon.com/gp/product/B005XU0V2E/)

Flow control
![4 channel relay board](https://www.amazon.com/dp/B0057OC5O8/)
![Solenoid Valve, 24V DC, 1/4" Tube OD, 40 Maximum PSI](https://www.mcmaster.com/#5489T653)
![John Guest Fitting, 1/4" Stem OD x 1/4" Hose ID (Pack of 10)](https://www.amazon.com/gp/product/B005XU0SK4/)

## Contributing

1. Clone repository. `git clone git@github.com:collectiveidea/localorbit.git`
2. Create a branch for your feature. `git checkout -b my-awesome-feature-name master`
3. Make changes and commit.
4. Run the tests. `rake`
5. Push to remote branch. `git push origin my-awesome-feature-name`
6. Create a Pull Request. Visit `https://github.com/collectiveidea/localorbit/compare/master...my-awesome-feature-name`

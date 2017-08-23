# Raspberry Pi 3 setup

## Create the Rasbpian Boot Disk
Use [Apple Pi Baker](https://www.tweaking4all.com/software/macosx-software/macosx-apple-pi-baker/) to create a boot disk from the [Raspbian Jessie Lite](https://downloads.raspberrypi.org/raspbian_lite_latest) image.

## Configuring SSH

Insert the SD card into your development machine and add a file named `ssh` to SD card's root directory.

Plug the Pi into the ethernet and find its ip address.

You can then ssh into the machine:

```
$ ssh pi@<ip address>
```

The default password for this user is `raspbian`.


## Update/Upgrade the System
```
$ sudo apt-get update
$ sudo apt-get dist-upgrade
```

## Setting up Wi-Fi
```
$ echo "network={\n\tssid=\"<ssid>\" psk=\"<wifi password>\"}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
```



### System Setup

```shell
sudo apt-get update
sudo apt-get dist-upgrade
sudo reboot

sudo raspi-config
sudo reboot

sudo apt-get install vim screen nodejs libcurl4-openssl-dev git libreadline6-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf ncurses-dev automake libtool bison
echo "startup_message off" > ~/.screenrc
echo "gem: --no-document" >> ~/.gemrc

echo "export RAILS_ENV=production" >> ~/.bashrc
echo "export CDPATH=.:/app/bender" >> ~/.bashrc
echo "export PATH=./bin:./.bin:$PATH" >> ~/.bashrc
echo "export EDITOR=/usr/bin/vim" >> ~/.bashrc


sudo mkdir /app
sudo chown pi:pi /app

wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.5.tar.gz
tar xzf ruby-2.2.5.tar.gz 
cd ruby-2.2.5/
./configure --prefix=/usr/local --enable-shared --disable-install-doc
make -j 4
sudo make install

cd
sudo gem i bundler
sudo apt-get install postgresql libpq-dev
sudo vi /etc/postgresql/9.4/main/pg_hba.conf
# change "peer" to "trust"

sudo /etc/init.d/postgresql reload
psql -U postgres
# CREATE ROLE bender_production;
# CREATE DATABASE bender_production;

git clone https://github.com/mruby/mruby.git
cd mruby/
git checkout 1.2.0

# Edit the build_config.rb file and add the following gems:
# 
#   conf.gem :github => 'iij/mruby-io'
#   conf.gem :github => 'ksss/mruby-signal'

./minirake
./bin/mruby -v

# Not sure where these are from
bunzip2 -c bender_production_2016-07-07.sql.bz2 | psql -U postgres bender_production


# Nginx
sudo gem install passenger
sudo passenger-install-nginx-module
wget http://downloads.sourceforge.net/project/pcre/pcre/8.32/pcre-8.32.tar.gz

sudo wget -O /etc/init.d/nginx https://github.com/Fleshgrinder/nginx-sysvinit-script/raw/master/init
sudo vi /etc/init.d/nginx

sudo chmod 755 /etc/init.d/nginx
sudo update-rc.d nginx defaults
sudo service nginx start

```


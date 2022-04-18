# Production Pi Setup

We're currently trying out [Docker Compose](https://docs.docker.com/compose/) for installation and [Overmind](https://github.com/DarthSim/overmind) for running the Ruby processes.

[Caddy](http://caddyserver.com) is the http server, which automatically sets up TLS certificates. It uses a self-signed cert for a local domain (like `bender.local`) and will get a real certification for a real domain. It uses DNS ACME validation, so the domain can point to a private IP address.

[Webhook Relay](http://webhookrelay.com) is set up so we can add users via external sources without needing to expose the pi to the internet.

Is this a good setup? I dunno, but it was a good blend of simple config and low-dependency installation. There are probably better ways. Please update the instructions when you switch!

## Initial Install

### Setup the Pi

1. Use Raspberry Pi Imager
2. Choose OS: Raspberry Pi OS Lite (64bit)
3. Advanced options: Set hostname to something like `bender.local`
4. Enable ssh and pick a password.
5. Set wifi settings (if desired)


### SSH into the Pi

```bash
ssh pi@bender.local
```

### Upgrade what's there:

```bash
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y
```

### Install Docker and Compose

```bash
curl -sSL https://get.docker.com | sh
```

```bash
sudo usermod -aG docker pi
```

```bash
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
```

```bash
mkdir -p $DOCKER_CONFIG/cli-plugins
```

```bash
curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-aarch64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
```

```bash
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
```

### Install git to pull the repo:

```bash
sudo apt-get install -y git
```

```bash
git clone https://github.com/collectiveidea/bender.git
```

```bash
cd bender
```

### Configure Environment

Create `~/bender/.env` on the Pi and copy over settings (see `.env.example`).

### Run the app

```bash
docker network create caddy
```

```bash
docker compose up -d
```

```bash
docker compose run web bin/setup
```

```bash
docker compose run web rake assets:precompile
```

## Updating Code

Update code with `git pull` and then rebuild the container(s). For example, to rebuild just the Rails app (`web` container):

```bash
docker compose up -d --build web
````

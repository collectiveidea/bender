# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.1

FROM ruby:$RUBY_VERSION
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY mruby_build_config.rb /myapp/mruby_build_config.rb
RUN bundle install

# mruby
RUN git clone https://github.com/mruby/mruby.git && cd mruby && git checkout 3.0.0 && MRUBY_CONFIG="/myapp/mruby_build_config.rb" rake && mv ./bin/mruby /usr/bin/mruby && /usr/bin/mruby -v

# Overmind
RUN apt-get install -y tmux
RUN curl -sL https://github.com/DarthSim/overmind/releases/download/v2.2.2/overmind-v2.2.2-linux-arm64.gz -o overmind.gz \
    && gunzip overmind.gz \
    && mv overmind /usr/bin/overmind \
    && chmod +x /usr/bin/overmind

# Add Node.js to sources list
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -
# Install Node.js version that will enable installation of yarn
RUN apt-get install -y --no-install-recommends \
    nodejs \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN npm install -g yarn

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

ENV MRUBY_BIN=/usr/bin/mruby
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RUBYOPT="--enable=frozen-string-literal"
ENV OVERMIND_NO_PORT=1

# Configure the main process to run when running the image
CMD ["overmind", "start", "-r", "web,monitor_temps,monitor_taps"]

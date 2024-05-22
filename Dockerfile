ARG RUBY_VERSION=3.3.1

FROM ruby:$RUBY_VERSION

RUN apt-get update -qq && apt-get upgrade -y && \
  apt-get install -y libcurl4 postgresql-client tmux && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Update Rubygems and Bundler
RUN \
  gem update --system --no-document && \
  gem install --no-document bundler

WORKDIR /app
COPY mruby_build_config.rb /app/mruby_build_config.rb

# mruby
RUN git clone https://github.com/mruby/mruby.git && cd mruby && git checkout 3.0.0 && MRUBY_CONFIG="/app/mruby_build_config.rb" rake && mv ./bin/mruby /usr/bin/mruby && /usr/bin/mruby -v

# Overmind
ARG OVERMIND_VERSION=2.5.1
RUN curl -sL "https://github.com/DarthSim/overmind/releases/download/v${OVERMIND_VERSION}/overmind-v${OVERMIND_VERSION}-linux-arm64.gz" -o overmind.gz \
    && gunzip overmind.gz \
    && mv overmind /usr/bin/overmind \
    && chmod +x /usr/bin/overmind

# Install JavaScript dependencies
ARG NODE_VERSION=20.13.1
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    corepack enable && \
    rm -rf /tmp/node-build-master

# Install Ruby dependencies
COPY Gemfile Gemfile.lock /app/
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

# Copy application code
COPY --link . .

# Install NodeJS dependencies
RUN npm install --package-lock-only

# Precompile bootsnap code for faster boot times
RUN \
  bundle exec bootsnap precompile app/ lib/ && \
  bundle exec rake assets:precompile && \
  bundle binstubs --force bundler

# Add a script to be executed every time the container starts.
ENTRYPOINT ["/app/entrypoint.sh"]
EXPOSE 3000

ENV MRUBY_BIN=/usr/bin/mruby
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RUBYOPT="--enable=frozen-string-literal"
ENV OVERMIND_NO_PORT=1

# Configure the main process to run when running the image
CMD ["overmind", "start", "-r", "web,monitor_temps,monitor_taps"]

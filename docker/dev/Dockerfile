FROM quay.io/nyulibraries/selenium_chrome_headless_ruby:2.6.2-slim-chrome_73

ENV INSTALL_PATH /app
ENV DOCKER true
ENV BUILD_PACKAGES bzip2 git libfontconfig libfreetype6 nodejs zlib1g-dev build-essential default-libmysqlclient-dev netcat

# Essential dependencies
RUN apt-get update -qq && apt-get install -y $BUILD_PACKAGES

RUN mkdir -p /bundle && chown 1000:2000 /bundle

# Add bundle entry point to handle bundle cache
COPY ./docker/dev/docker-entrypoint.sh /docker/dev/wait-for.sh ./
RUN chmod +x /docker-entrypoint.sh /wait-for.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker

USER docker

WORKDIR $INSTALL_PATH

# Add github to known_hosts
RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

COPY --chown=docker:docker Gemfile Gemfile.lock ./

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle \
    BUNDLE_INSTALL_WITHOUT='no_docker production'
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN gem install bundler -v 2.0.1
# Comment out below line to use volume as a gems cache at runtime
# This is especially useful if you're rapidly testing new Gem versions
RUN bundle config --global github.https true && \
  bundle install --without $BUNDLE_INSTALL_WITHOUT --binstubs="$BUNDLE_BIN"

# Copy source into container
COPY --chown=docker:docker . .
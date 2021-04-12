FROM ruby:2.6.2-alpine3.9

ENV DOCKER true
ENV INSTALL_PATH /app
ENV BUNDLE_PATH /usr/local/bundle

RUN addgroup -g 1000 -S docker && \
  adduser -u 1000 -S -G docker docker

WORKDIR $INSTALL_PATH
RUN chown docker:docker .

COPY --chown=docker:docker bin/ bin/
COPY --chown=docker:docker Gemfile Gemfile.lock ./
ARG RUN_PACKAGES="ca-certificates fontconfig nodejs nodejs-npm tzdata mariadb-dev"
ARG BUILD_PACKAGES="ruby-dev build-base git shared-mime-info"
ARG BUNDLE_INSTALL_WITHOUT='no_docker test development'
RUN apk add --no-cache --update $RUN_PACKAGES $BUILD_PACKAGES \
  && gem install bundler \
  && bundle config --local github.https true \
  && bundle install --without $BUNDLE_INSTALL_WITHOUT --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle
RUN npm install --global yarn

USER docker

# Copies necessary Rails files for running and generating assets
COPY --chown=docker:docker ./app ./app
COPY --chown=docker:docker ./config ./config
COPY --chown=docker:docker ./db ./db
COPY --chown=docker:docker ./lib ./lib
COPY --chown=docker:docker ./public ./public
COPY --chown=docker:docker ./vendor ./vendor
COPY --chown=docker:docker Rakefile Rakefile
COPY --chown=docker:docker config.ru config.ru
COPY --chown=docker:docker ./script ./script

# Precompiles production assets with randomized secret
RUN RAILS_ENV=production SECRET_TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) \
  bundle exec rake assets:precompile
  
USER docker
EXPOSE 5000

CMD ./script/start.sh production
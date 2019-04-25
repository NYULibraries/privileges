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
ARG BUILD_PACKAGES="ruby-dev build-base git"
RUN apk add --no-cache --update $RUN_PACKAGES $BUILD_PACKAGES \
  && gem install bundler \
  && bundle config --local github.https true \
  && bundle install --without no_docker test development cucumber --jobs 20 --retry 5 \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache \
  && apk del $BUILD_PACKAGES \
  && chown -R docker:docker /usr/local/bundle
RUN npm install --global yarn

USER docker
COPY --chown=docker:docker . .
# Precompiles production assets with randomized secret
RUN RAILS_ENV=production SECRET_TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) \
  bundle exec rake assets:precompile

# run microscanner
USER root
ARG AQUA_MICROSCANNER_TOKEN
RUN wget -O /microscanner https://get.aquasec.com/microscanner && \
  chmod +x /microscanner && \
  /microscanner ${AQUA_MICROSCANNER_TOKEN} && \
  rm -rf /microscanner

USER docker
EXPOSE 5000

CMD ./script/start.sh production
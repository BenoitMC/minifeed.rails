FROM ruby:4.0.1-trixie AS base

RUN apt-get update \
  && apt-get install -y --no-install-recommends libjemalloc2 postgresql-client \
  && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV \
  RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/app/vendor/bundle" \
  BUNDLE_WITHOUT="development test" \
  LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"



FROM base AS build
COPY . /code
ENV SECRET_KEY_BASE_DUMMY=0
RUN \
  apt-get update && \
  apt-get install -y nodejs npm libpq-dev && \
  npm install --global yarn && \
  cd /code && \
  mkdir /app && \
  git archive HEAD | tar -x -f - -C /app && \
  cd /app && \
  gem install bundler && \
  bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile && \
  bundle exec bootsnap precompile app/ lib/ && \
  yarn install && \
  bundle exec rake assets:precompile && \
  rm -rf node_modules



FROM base
COPY --from=build /app /app
WORKDIR /app
CMD ["/app/bin/start"]

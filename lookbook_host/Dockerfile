# syntax=docker/dockerfile:1
# Build from repo root:
#   docker build -f lookbook_host/Dockerfile -t maglev-lookbook:local .
#
# Small image: Alpine Ruby base + only engine files declared in maglevcms.gemspec,
# lookbook_host, and spec/components/previews (no spec/dummy, no full-repo COPY).

FROM ruby:3.4.6-alpine AS builder

RUN apk add --no-cache build-base yaml-dev pkgconf tzdata

ENV APP_HOME=/app \
    BUNDLE_WITHOUT=development:test \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=production

WORKDIR ${APP_HOME}

# Path gem root (parent of lookbook_host): files required by maglevcms.gemspec
COPY maglevcms.gemspec MIT-LICENSE Rakefile README.md ${APP_HOME}/
COPY app/ ${APP_HOME}/app/
COPY lib/ ${APP_HOME}/lib/
COPY config/ ${APP_HOME}/config/
COPY db/ ${APP_HOME}/db/
COPY exe/ ${APP_HOME}/exe/
COPY vendor/ ${APP_HOME}/vendor/

COPY lookbook_host/ ${APP_HOME}/lookbook_host/
COPY spec/components/previews/ ${APP_HOME}/spec/components/previews/

WORKDIR ${APP_HOME}/lookbook_host

RUN bundle install --jobs 4 --retry 3 && \
    SECRET_KEY_BASE=precompile_placeholder bundle exec rails assets:precompile && \
    rm -rf tmp/cache "${APP_HOME}/lookbook_host/tmp/cache"

# tailwindcss-ruby (~100MB) is only needed for maglev:tailwindcss:build during precompile (see exe/tailwind-cli + maglev_tasks).
# Bundler installs under ${BUNDLE_PATH}/ruby/<version>/, not ${BUNDLE_PATH}/gems.
RUN set -eux; \
    rm -rf "${BUNDLE_PATH}/ruby/"*/cache "${BUNDLE_PATH}/ruby/"*/doc; \
    rm -rf "${BUNDLE_PATH}/ruby/"*/gems/tailwindcss-ruby-*; \
    rm -f "${BUNDLE_PATH}/ruby/"*/specifications/tailwindcss-ruby-*.gemspec; \
    find "${BUNDLE_PATH}/ruby" -type d -path '*/extensions/*' -name 'tailwindcss-ruby-*' -prune -exec rm -rf {} + 2>/dev/null || true; \
    find "${BUNDLE_PATH}/ruby/"*/gems -mindepth 2 -maxdepth 2 -type d \( \
      -name spec -o -name test -o -name tests -o -name benchmarks -o -name docs -o -name examples \
    \) -exec rm -rf {} + 2>/dev/null || true; \
    find "${BUNDLE_PATH}/ruby/"*/gems -type f \( \
      -iname 'changelog*' -o -iname 'readme*' -o -iname 'history*' -o -iname 'contributing*' \
    \) -delete 2>/dev/null || true; \
    find "${BUNDLE_PATH}" -type f -name '*.gem' -delete 2>/dev/null || true

FROM ruby:3.4.6-alpine

RUN apk add --no-cache yaml tzdata

ENV APP_HOME=/app \
    BUNDLE_WITHOUT=development:test \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=production \
    TZ=UTC \
    PATH=/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

WORKDIR ${APP_HOME}

COPY --from=builder ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=builder ${APP_HOME} ${APP_HOME}

WORKDIR ${APP_HOME}/lookbook_host

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

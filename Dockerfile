FROM ruby:3.0.0-alpine3.12

COPY Gemfile Gemfile.lock /app/

WORKDIR /app

RUN apk --no-cache add --virtual .eventmachine-builddeps g++ musl-dev make \
  && bundle install --deployment --without test development

EXPOSE 3000

ENV RACK_ENV production
ENV SERVE_ASSETS 1

COPY . /app

ENTRYPOINT ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]

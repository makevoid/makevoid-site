FROM ruby:alpine

COPY Gemfile Gemfile.lock /app/

WORKDIR /app

RUN apk --no-cache add --virtual .eventmachine-builddeps g++ musl-dev make \
  && bundle install --deployment --without test development

EXPOSE 9292

ENV RACK_ENV production
ENV SERVE_ASSETS 1

COPY . /app

ENTRYPOINT ["bundle", "exec", "rackup", "-o", "0.0.0.0"]

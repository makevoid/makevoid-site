FROM ruby:3.2.2-alpine

RUN mkdir -p /app
RUN mkdir -p /app/config

COPY Gemfile Gemfile.lock /app/
COPY .bundle /app/.bundle

WORKDIR /app

RUN apk --no-cache add --virtual .eventmachine-builddeps g++ musl-dev make \
  && bundle install --deployment --without test development

EXPOSE 3000

ENV RACK_ENV production
ENV SERVE_ASSETS 1

COPY ./ /app/

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]

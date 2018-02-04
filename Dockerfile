FROM ruby:alpine

COPY Gemfile Gemfile.lock /app/

WORKDIR /app

RUN apk --no-cache add --virtual .eventmachine-builddeps g++ musl-dev make \
  && bundle install --deployment --without test development

COPY . /app

EXPOSE 9292

ENTRYPOINT ["bundle", "exec", "rackup", "-o", "0.0.0.0"]

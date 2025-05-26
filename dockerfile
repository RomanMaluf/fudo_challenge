ARG RUBY_VERSION=3.3.0
FROM docker.io/library/ruby:$RUBY_VERSION-slim

WORKDIR /app
COPY . /app

RUN gem install bundler && bundle install

EXPOSE 9292
CMD ["rackup", "-o", "0.0.0.0"]

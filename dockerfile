ARG RUBY_VERSION=3.3.0
FROM docker.io/library/ruby:$RUBY_VERSION-slim


RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:$(tail -1 Gemfile.lock | xargs)
RUN bundle install

COPY . .

EXPOSE 9292
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "9292"]

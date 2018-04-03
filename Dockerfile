FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle pack
RUN bundle install --path=vendor/bundle
RUN bundle install --path vendor/cache
RUN bundle install

ADD . /app
WORKDIR /app
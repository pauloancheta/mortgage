FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
WORKDIR /it_glue

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

COPY . .

ENTRYPOINT ["bundle", "exec", "rails", "server", "-p", "3000"]

FROM ruby:3.1-bookworm
RUN apt-get update && apt-get install -y --no-install-recommends build-essential git nodejs imagemagick libmagickwand-dev default-libmysqlclient-dev libicu-dev libxml2-dev libxslt1-dev zlib1g-dev libyaml-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.6 && bundle config set without 'development test assets' && bundle install -j4
COPY . ./
RUN mkdir -p tmp/pids log public/uploads && SECRET_KEY_BASE=x DB_PASSWORD=x bundle exec rake assets:precompile
ENV RAILS_ENV=production RAILS_SERVE_STATIC_FILES=true PORT=3000
EXPOSE 3000
CMD ["bundle","exec","puma","-C","config/puma.rb"]

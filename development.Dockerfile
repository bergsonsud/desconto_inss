FROM ruby:3.3.0
ENV BUNDLER_VERSION=2.2.32

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    curl \
    build-essential \
    gnupg2 \
    less \
    git \
    libpq-dev \
    postgresql-client \
    libvips42 && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install nodejs yarn \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install bundler -v 2.5.3

WORKDIR /app
COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3

COPY . ./

EXPOSE 3000 1080

CMD ["sleep","infinity"]

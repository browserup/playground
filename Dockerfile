# Base image
FROM --platform=linux/amd64 ruby:3.4.1

RUN mkdir /app
# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
        build-essential \          # Compiler tools for native extensions
        autoconf \                 # Automatic configuration generator
        libtool \                  # Library tools
        pkg-config \               # Package configuration tool
        libssl-dev \               # SSL/TLS libraries
        zlib1g-dev \               # Compression libraries
        libprotobuf-dev \          # Protobuf library
        protobuf-compiler \        # Protobuf compiler
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install app dependencies
COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 3

# Copy the app code
COPY . .

# Set environment variables
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

# Run database migrations
RUN bundle exec rails db:migrate
RUN bundle exec rails db:seed
RUN bundle exec rails assets:precompile

EXPOSE 3000

# Start the app server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


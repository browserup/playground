# Base image
FROM --platform=linux/amd64 ruby:3.4.1
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY

RUN mkdir /app
# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
        build-essential \
        autoconf \
        libtool \
        pkg-config \
        libssl-dev \
        zlib1g-dev \
        libprotobuf-dev \
        protobuf-compiler \
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
ENV RAILS_MASTER_KEY=your_master_key_here

# Run database migrations
RUN bundle exec rails db:migrate
RUN bundle exec rails db:seed
RUN bundle exec rails assets:precompile

EXPOSE 3000

# Start the app server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


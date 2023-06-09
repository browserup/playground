# Base image
FROM --platform=linux/amd64 ruby:3.1.3

RUN mkdir /app
# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs && \
    apt-get clean && \
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


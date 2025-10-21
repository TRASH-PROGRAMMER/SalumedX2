# Dockerfile
FROM ruby:3.1

WORKDIR /app

COPY Gemfile Gemfile.lock* ./
RUN bundle install --without development test

COPY . .

EXPOSE 4000

CMD ["bundle", "exec", "ruby", "app.rb", "-o", "0.0.0.0", "-p", "4000"]

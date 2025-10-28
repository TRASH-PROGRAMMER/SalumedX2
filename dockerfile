FROM ruby:3.3

WORKDIR /app

# Copiar solo Gemfile y Gemfile.lock primero (mejor para cache)
COPY Gemfile Gemfile.lock ./

# Instalar dependencias antes de copiar el resto
RUN gem install bundler && bundle install

# Ahora sí, copiar el resto del proyecto
COPY . .

EXPOSE 4000

CMD ["ruby", "app.rb"]

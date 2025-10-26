# Dockerfile
FROM ruby:3.4

WORKDIR /app

# Copiar la aplicación
COPY . .

# Instalar sinatra
RUN gem install sinatra

# Puerto por defecto
EXPOSE 4000

# Comando para ejecutar la aplicación
CMD ["ruby", "app.rb"]

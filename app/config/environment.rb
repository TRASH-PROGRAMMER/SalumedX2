# file: environment.rb
# Load environment variables from .env file
require 'bundler/setup'
require 'dotenv/load'

require 'sinatra'
require 'json'
require 'graphql'
require 'httparty'
require 'batch_loader'
require 'rack/cors'

# 🔹 Cargar configuración del servidor (conexión REST)
require_relative '../config/server_config'

# 🔹 Cargar servicios, resolvers y schema
Dir[File.join(__dir__, "..","service","*.rb")].each { |f| require f }
Dir[File.join(__dir__, "..","resolvers","*.rb")].each { |f| require f }
Dir[File.join(__dir__, "..","schema","**","*.rb")].each { |f| require f }

require 'bundler/setup'
require 'dotenv/load'

require 'sinatra'
require 'json'
require 'graphql'
require 'faraday'
require 'batch_loader'


require 'rack/cors'

Dir[File.join(__dir__, "..","services","*.rb")].each { |f| require f}
Dir[File.join(__dir__, "..", "resolvers", "*.rb")].each { |f| require f }
Dir[File.join(__dir__, "..", "schema", "**", "*.rb")].each { |f| require f }
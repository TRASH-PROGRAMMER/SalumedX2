require 'sinatra'
require 'json'
require 'graphql'
require 'rack/cors'
require_relative './config/server_config'
require_relative './service/rest_service'
require_relative './schema/salumedx_schema'

class GraphqlService < Sinatra::Base
  configure do
    set :port, ServerConfig.port
    set :bind, ServerConfig.bind_address
    set :environment, ServerConfig.environment

    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end

  post '/graphql' do
    body = request.body.read
    payload = body.empty? ? {} : JSON.parse(body)
    query = payload['query']
    variables = payload['variables'] || {}
    operation_name = payload['operationName']

    context = {
      rest: RestService.new(ServerConfig.rest_api_url)
    }

    result = SalumedxSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )

    content_type :json
    result.to_json
  rescue StandardError => e
    ServerConfig.logger.error(e.message)
    status 500
    { errors: [{ message: e.message }] }.to_json
  end

  get '/health' do
    content_type :json
    { status: 'ok', service: 'GraphQL', config: ServerConfig.summary }.to_json
  end
end

GraphqlService.run! if __FILE__ == $PROGRAM_NAME




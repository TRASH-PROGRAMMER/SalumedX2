require 'sinatra'
require 'json'
require 'graphql'
require 'rack/cors'
require_relative './app/resolvers/farmacias_resolver'
require_relative './schema/salumedx_schema'
# Definición de la clase GraphqlService que hereda de Sinatra::Base
class GraphqlService < Sinatra::Base
  configure do
    set :port, ENV.fetch('PORT', 4000).to_i
    set :bind, '0.0.0.0'
# Configurar CORS
    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end
# Endpoint para consultas GraphQL
  post '/graphql' do
    request_body = request.body.read
    payload = request_body && request_body.length > 0 ? JSON.parse(request_body) : {}
    query = payload['query'] || params['query']
    variables = payload['variables'] || params['variables']
    variables = JSON.parse(variables) if variables.is_a?(String) && variables.strip.start_with?('{')
    operation_name = payload['operationName'] || params['operationName']
# Configurar el contexto con SupabaseService
    context = {
      supabase: SupabaseService.new(
        ENV.fetch('SUPABASE_URL'),
        ENV.fetch('SUPABASE_API_KEY')
      )
    }
# Ejecutar la consulta GraphQL
    result = SalumedxSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
# Responder con el resultado en formato JSON
    content_type :json
    status 200
    result.to_json
  rescue JSON::ParserError => e
    status 400
    { errors: [{ message: "JSON malformado o JSON inválido: #{e.message}" }] }.to_json
  rescue StandardError => e
    status 500
    { errors: [{ message: "Error interno del servidor: #{e.message}" }] }.to_json
  end
# Endpoint de salud
  get '/health' do
    content_type :json
    {
      status: 'ok',
      service: 'GraphQL Service',
      env: ENV['RACK_ENV'] || 'development'
    }.to_json
  end
end
# Ejecutar el servicio si se ejecuta este archivo directamente
if __FILE__ == $0
  GraphqlService.run!
end



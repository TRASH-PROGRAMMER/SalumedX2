# schema/salumedx_schema.rb
require 'batch-loader'
require_relative 'types/query_type'
require_relative 'types/farmacia_type'
require_relative 'types/producto_type'
# clase para definir el esquema de GraphQL
=begin
La clase SalumedxSchema en Ruby hereda de GraphQL::Schema.
Define el tipo de consulta principal (query type) 
que permite realizar las operaciones GraphQL de la aplicación y utiliza BatchLoader::GraphQL para optimizar la carga de datos, 
evitando consultas repetidas o innecesarias.
=end
class SalumedxSchema < GraphQL::Schemac
  query(Types::QueryType)
  mutation(Types::MutationType) # futuro opcional
  use BatchLoader::GraphQL

  rescue_from(StandardError) do |err|
    GraphQL::ExecutionError.new("Error interno del servidor: #{err.message}")

  end


end
# schema/salumedx_schema.rb
require 'batch-loader'
require_relative 'Types/query_type'
require_relative 'Types/farmacia_type'
require_relative 'Types/producto_type'

class SalumedxSchema < GraphQL::Schema
  query(Types::QueryType)
  use BatchLoader::GraphQL
end

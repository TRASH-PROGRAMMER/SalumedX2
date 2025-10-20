# schema/salumedx_schema.rb
class SalumedxSchema < GraphQL::Schema
  query(Types::QueryType)
  use BatchLoader::GraphQL
end

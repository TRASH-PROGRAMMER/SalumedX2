# schema/types/producto_type.rb
module Types
  class ProductoType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :nombre, String, null: false
    field :precio, Float, null: true
    field :presentacion, String, null: true
    field :stock, Integer, null: true
  end
end

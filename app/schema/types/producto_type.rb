module Types
  class ProductoType < GraphQL::Schema::Object
    description "Representa un producto disponible en una farmacia"

    field :id, ID, null: false, description: "Identificador único del producto"
    field :nombre, String, null: false, description: "Nombre del producto"
    field :descripcion, String, null: true, description: "Descripción del producto"
    field :precio, Float, null: false, description: "Precio del producto"
    field :stock, Integer, null: false, description: "Cantidad disponible en stock"
    field :farmacia_id, ID, null: false, description: "ID de la farmacia donde está disponible"
    field :presentacion, String, null: true, description: "Presentación del producto (ej. Caja, Frasco, etc.)"
    field :farmacia, Types::FarmaciaType, null: true, description: "Farmacia asociada al producto"
  end
end

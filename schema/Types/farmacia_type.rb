requiere_relative 'producto_type'
# schema/types/farmacia_type.rb
module type
  # Tipo de entidad Farmacia
  class FarmaciaType < Graphql::schema:Object
    description "Representa una farmacia con sus detalles y productos disponibles"

    field :id, ID, null: false, description: "Identificador único de la farmacia"
    field :nombre, String, null: false, description: "Nombre de la farmacia"
    field :direccion, String, null: false, description: "Dirección de la farmacia"
    field :latitud, Float, null: false, description: "Latitud de la ubicación de la farmacia"
    field :longitud, Float, null: false, description: "Longitud de la ubicación de la farmacia"
    field :distancia_km, Float, null: false, description: "Distancia desde el punto de referencia en kilómetros"
    field :productos, [Types::ProductoType], null: true, description: "Lista de productos disponibles en la farmacia"

  end
end
require_relative 'producto_type'

module Types
  class FarmaciaType < GraphQL::Schema::Object
    description "Representa una farmacia con sus detalles y productos disponibles"

    field :id, ID, null: false, description: "Identificador único de la farmacia"
    field :nombre, String, null: false, description: "Nombre de la farmacia"
    field :direccion, String, null: false, description: "Dirección de la farmacia"
    field :lat, Float, null: true, description: "Latitud de la ubicación de la farmacia"
    field :lng, Float, null: true, description: "Longitud de la ubicación de la farmacia"
    field :distancia_km, Float, null: true, description: "Distancia desde el punto de referencia en kilómetros"

    # Relación: productos disponibles en esta farmacia
    field :productos, [Types::ProductoType], null: true, description: "Lista de productos disponibles en la farmacia" do
      resolve ->(obj, _args, ctx) {
        BatchLoader.for(obj['id']).batch do |farmacia_ids, loader|
          farmacia_ids.each do |fid|
            response = ctx[:rest].get("/productos/?farmacia_id=#{fid}")
            productos = JSON.parse(response.body)
            loader.call(fid, productos)
          end
        end
      }
    end
  end
end


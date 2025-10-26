require_relative 'farmacia_type'

module Types
  class QueryType < GraphQL::Schema::Object
    description "Punto de entrada para consultas SalumedX"

    field :farmacias_cercanas, [Types::FarmaciaType], null: false do
      description "Encuentra farmacias cercanas a una ubicación"
      argument :lat, Float, required: true, description: "Latitud de la ubicación"
      argument :lng, Float, required: true, description: "Longitud de la ubicación"
      argument :radio, Integer, required: false, default_value: 5, description: "Radio de búsqueda en kilómetros"
      argument :nombre_producto, String, required: false, description: "Nombre del producto para filtrar farmacias"
    end

    def farmacias_cercanas(lat:, lng:, radio:, nombre_producto: nil)
      resolver = FarmaciasResolver.new(context[:supabase])
      resolver.farmacias_cercanas(
        lat: lat,
        lng: lng,
        radio: radio,
        nombre_producto: nombre_producto
      )
    end
  end
end













module Types # schema/types/query_type.rb
  # Tipo Query principal para SalumedX
  class QueryType < GraphQL::Schema::Object
    description "Punto de entrada para consultas SaluumedX"
    argument :lat, Float, required: true 
    argument :lng, Float, required: true
    argument :radio,integer, required: falase, default_value: 5
    argument :nombre_producto, String, required: false
  end
# Llama al resolvedor FarmaciasResolver
  def farmacias_cercanas(lat:, lng:, radio:, nombre_producto: nil)
    resolver = FarmaciasResolver.(context[:supabase])
    resolver.farmacias_cercanas(lat: lat, lng: lng, radio: radio, nombre_producto: nombre_producto)
    end
  end













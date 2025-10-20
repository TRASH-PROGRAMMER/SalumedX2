# resolvers/farmacia_resolver.rb
require 'batch_loader'
#  resolvedor para manejar la lógica de negocio relacionada con las farmacias
class FarmaciaResolver
  def initialize(supabase_service)
    @supabase = supabase_service
  end
# Método para obtener las farmacias cercanas a un punto de referencia
  
  def farmacias_cercanas(lat:, lng:, radio: 5, producto: nil)
    farmacias = @supabase.get_farmacias_cercanas(lat, lng, radio)
# Mapear los datos de las farmacias al formato esperado por GraphQL
    farmacias.map do |f|
      {
        id: f['id'],
        nombre: f['nombre'],
        direccion: f['direccion'],
        lat: f['lat'],
        lng: f['lng'],
        distancia_km: f['distancia_km'],
        # Cargar los productos asociados a la farmacia
        productos: BatchLoader.for(f['id']).batch(key: :productos_por_farmacia) do |farmacia_ids, loader|
        # Obtener todos los productos para las farmacias en el lote
          all_products = @supabase.get_productos_por_farmacias(farmacia_ids, producto)
          all_products.group_by { |p| p['farmacia_id'] }.each do |farm_id, prods|
            loader.call(farm_id, prods)
          end
        end,
        end
      }
    end
  end
end

class FarmaciaService
  # Constructor de la clase FarmaciaService
  def initialize(supabase)
    @supabase = supabase
  end
# Lógica de negocio: recomendación de farmacias cercanas con mejores precios
  def recomendar_farmacias(lat:, lng:, radio:, nombre_producto: nil)
    farmacias = @supabase.get_farmacias_cercanas(lat, lng, radio)
    productos =@supabase.buscar_productos_por_nombre(nombre_producto)
    # Filtrar productos por farmacia y calcular el precio mínimo
    resultado = farmacias.map do |f|
    productos_filtrados = productos.select { |p| p['farmacia_id'] == f['id'] }
    precio_nimnimo = productos_filtrados.map { |p| p['precio'] }.min
    {
      id: f['id'],
      nombre: f['nombre'],
      direccion: f['direccion'],
      lat: f['lat'],
      lng: f['lng'],
      distancia_km: f['distancia_km'],
      precio: precio
      precio_nimnimo: precio_nimnimo
    }
  end
  # Ordenar las farmacias por precio mínimo y distancia
  resultado.sort_by { |f| [f[:precio_nimnimo], f[:distancia_km]] }
  end
endç
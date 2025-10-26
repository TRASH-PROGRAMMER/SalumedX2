class FarmaciasResolver
  def initialize(supabase_client)
    @supabase = supabase_client
  end

  def farmacias_cercanas(lat:, lng:, radio:, nombre_producto: nil)
    # Query a Supabase para encontrar farmacias cercanas
    query = @supabase
      .from('farmacias')
      .select('*, productos(*)')
      .function('ST_DWithin', 
        'ST_SetSRID(ST_MakePoint(longitud, latitud), 4326)',
        "ST_SetSRID(ST_MakePoint(#{lng}, #{lat}), 4326)",
        radio * 1000 # convertir km a metros
      )

    # Filtrar por producto si se especifica
    if nombre_producto
      query = query.contains('productos.nombre', nombre_producto)
    end

    # Ejecutar la consulta
    response = query.execute

    if response.error
      raise GraphQL::ExecutionError, "Error al consultar farmacias: #{response.error.message}"
    end

    # Transformar resultados
    response.data.map do |farmacia|
      {
        id: farmacia['id'],
        nombre: farmacia['nombre'],
        direccion: farmacia['direccion'],
        latitud: farmacia['latitud'],
        longitud: farmacia['longitud'],
        distancia_km: calculate_distance(lat, lng, farmacia['latitud'], farmacia['longitud']),
        productos: farmacia['productos']
      }
    end
  end

  private

  def calculate_distance(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI/180
    rm = 6371 # Radio medio de la Tierra en kilómetros

    dlat_rad = (lat2-lat1) * rad_per_deg
    dlon_rad = (lon2-lon1) * rad_per_deg

    lat1_rad = lat1 * rad_per_deg
    lat2_rad = lat2 * rad_per_deg

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    rm * c # Distancia en kilómetros
  end
end
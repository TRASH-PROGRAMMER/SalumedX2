# models/farmacia.rb
class Farmacia
  attr_accessor :id, :nombre, :direccion, :lat, :lng, :distancia_km

  def initialize(attrs = {})
    @id = attrs['id']
    @nombre = attrs['nombre']
    @direccion = attrs['direccion']
    @lat = attrs['lat']
    @lng = attrs['lng']
    @distancia_km = attrs['distancia_km']
  end

  def to_h
    {
      id: id,
      nombre: nombre,
      direccion: direccion,
      lat: lat,
      lng: lng,
      distancia_km: distancia_km
    }
  end
end

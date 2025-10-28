# models/farmacia.rb
class Farmacia
  # Agregar otros atributos según sea necesario
  attr_accessor :id, :nombre, :direccion, :lat, :lng, :distancia_km 
# Constructor para inicializar una farmacia desde un hash de atributos
  def initialize(attrs = {})
    @id = attrs['id']
    @nombre = attrs['nombre']
    @direccion = attrs['direccion']
    @lat = attrs['lat']
    @lng = attrs['lng']
    @distancia_km = attrs['distancia_km']
  end
# Método para obtener el hash con los atributos de la farmacia
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

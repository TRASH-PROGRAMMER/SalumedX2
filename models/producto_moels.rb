# models/producto.rb
class Producto
  attr_accessor :id, :nombre, :precio, :presentacion, :stock, :farmacia_id
# Constructor que inicializa un objeto Producto con los atributos proporcionados
  def initialize(attrs = {})
    @id = attrs['id']
    @nombre = attrs['nombre']
    @precio = attrs['precio'].to_f
    @presentacion = attrs['presentacion']
    @stock = attrs['stock'].to_i
    @farmacia_id = attrs['farmacia_id']
  end
# Método para obtener el hash con los atributos del producto
  def to_h
    {
      id: id,
      nombre: nombre,
      precio: precio,
      presentacion: presentacion,
      stock: stock,
      farmacia_id: farmacia_id
    }
  end
end

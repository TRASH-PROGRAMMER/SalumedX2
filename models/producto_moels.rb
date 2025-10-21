# models/producto.rb
class Producto
  attr_accessor :id, :nombre, :precio, :presentacion, :stock, :farmacia_id

  def initialize(attrs = {})
    @id = attrs['id']
    @nombre = attrs['nombre']
    @precio = attrs['precio'].to_f
    @presentacion = attrs['presentacion']
    @stock = attrs['stock'].to_i
    @farmacia_id = attrs['farmacia_id']
  end

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

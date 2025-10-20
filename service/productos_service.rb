class ProductosService
  # Constructor de la clase ProductosService
  def initialize(supabase)
    @supabase = supabase
  end
  def calcular_factura(productos)
    raise ArgumentError, 'lista de productos vacia' if productos.nil? || productos.empty?

    total = productos.sum do |prod|
    precio = @supabase.obtener_precio_producto(prod[:producto_id], prod[:farmacia_id])
    precio * (prod[:cantidad] || 1)
    end
    {
      subtotal: total,
      iva:(total * 0.15).round(2),
      total: (total + total * 0.15).round(2)
    }
  end

  def comparar_precios(nombre_producto)
    datos = @supabase.buscar_productos_por_nombre(nombre_producto)
    datos.map do |p|
      {
        id: p['id'],
        nombre: p['nombre'],
        precio: p['precio'],
      }
      end.sort_by { |r| r[:precio] }
  end
end
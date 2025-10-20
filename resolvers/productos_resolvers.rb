# resolvers/productos_resolvers.rb
# resolvedor para manejar la lógica de negocio relacionada con los productos
class ProductoResolver
  def initialize(supabase_service)
    @supabase = supabase_service
  end
  # Método para buscar productos por nombre
  def buscar_productos(nombe:)
    raise ArgumentError, 'El nombre del producto es obligatorio' if nombe.nil? || nombe.strip.empty?
# Obtener productos que coincidan con el nombre dado
    productos = @supabase.buscar_productos_por_nombre(nombe)
    productos.map do |p|
      {
        id: p['id'],
        nombre: p['nombre'],
        precio: p['precio'],
        presentacion: p['presentacion'],
        stock: p['stock']
      }
    end
  end

require 'json'

class RecetasResolver
  def initialize(rest_service)
    @recetas_service = RecetasService.new(rest_service)
  end

  def obtener_recetas
    data = @recetas_service.obtener_recetas
    data.map { |r| RecetaModel.new(r) }
  end

  def obtener_receta_por_id(id)
    data = @recetas_service.obtener_recetas(id)
    RecetaModel.new(data)
  end
end

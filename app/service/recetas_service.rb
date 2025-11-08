require 'json'

class RecetasService
  def initialize(rest_service)
    @rest = rest_service
  end

  # Obtiene todas las recetas o una específica
  def obtener_recetas(receta_id = nil)
    path = receta_id ? "/recetas/#{receta_id}/" : "/recetas/"
    res = @rest.get(path)
    parse_json!(res)
  end

  # Obtiene los detalles de una receta específica
  def obtener_detalles(receta_id)
    path = "/detalle-prescripcion/?receta_id=#{receta_id}"
    res = @rest.get(path)
    parse_json!(res)
  end

  private

  def parse_json!(res)
    raise "Sin respuesta del REST" unless res
    code = res.code.to_i rescue 200
    raise "Error REST #{code}" unless code.between?(200, 299)
    JSON.parse(res.body.to_s)
  end
end

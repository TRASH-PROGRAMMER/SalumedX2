# models/receta.rb
class RecetaModel
  attr_accessor :id, :fecha_emision, :paciente_id, :medico_id, :observaciones, :detalles

  def initialize(data)
    @id             = data['id']
    @fecha_emision  = data['fecha_emision'] || data['fecha'] || "Sin fecha"
    @paciente_id    = data['paciente_id']
    @medico_id      = data['medico_id']
    @observaciones  = data['observaciones'] || "Sin observaciones"
    @detalles       = (data['detalles'] || []).map { |d| DetallePrescripcionModel.new(d) }
  end
end

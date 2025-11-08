# app/schema/types/receta_type.rb
require_relative 'detalle_type'
module Types
  class RecetaType < GraphQL::Schema::Object
    description "Representa una receta médica emitida por un médico a un paciente"

    field :id, ID, null: false
    field :fecha_emision, String, null: true
    field :paciente_id, ID, null: false
    field :medico_id, ID, null: false
    field :observaciones, String, null: true
    field :detalles, [Types::DetallePrescripcionType], null: true
  end
end

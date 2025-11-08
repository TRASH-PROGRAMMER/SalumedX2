module Types
  class DetallePrescripcionType < GraphQL::Schema::Object
    description "Detalle de una prescripción médica"

    field :id, ID, null: false
    field :producto_id, ID, null: false
    field :producto_nombre, String, null: false
    field :dosis, String, null: true
    field :frecuencia, String, null: true
    field :duracion, String, null: true
    field :indicaciones, String, null: true
  end
end

module Types
  class QueryType < Types::BaseObject
    field :recetas, [Types::RecetaType], null: false, description: "Obtiene todas las recetas"
    def recetas
      resolver = RecetasResolver.new(context[:rest])
      resolver.obtener_recetas
    end
    
    field :receta, Types::RecetaType, null: true do
      description "Obtiene una receta por ID"
      argument :id, ID, required: true
    end
    def receta(id:)
      resolver = RecetasResolver.new(context[:rest])
      resolver.obtener_receta_por_id(id)
end
  end
end


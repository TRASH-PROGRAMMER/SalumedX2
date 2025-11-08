# schema/types/mutation_type.rb
require_relative '../../service/pdf_service'
require_relative '../../service/rest_service'

module Types
  class MutationType < GraphQL::Schema::Object
    description "Mutations de SaluuMedX"

    field :generar_receta_pdf, Types::PdfResponseType, null: false do
      description "Genera un PDF de receta médica obteniendo los datos reales desde el REST"
      argument :paciente, GraphQL::Types::JSON, required: true
      argument :medico, GraphQL::Types::JSON, required: true
    end

    def generar_receta_pdf(paciente:, medico:)
      begin
        # Crear instancia del cliente REST (usa URL del Django REST API)
        rest = RestService.new("https://salumedx-rest.onrender.com")

        # --- 1️⃣ Obtener productos reales desde el REST ---
        response = rest.get("/productos/")
        raise "Error en la respuesta REST" unless response.code.to_i.between?(200, 299)

        productos = JSON.parse(response.body)

        # --- 2️⃣ Formatear productos (solo los necesarios para el PDF) ---
        productos_pdf = productos.first(5).map do |p|
          {
            "nombre" => p["nombre"],
            "presentacion" => p["presentacion"],
            "cantidad" => p["stock"] || 1,
            "precio" => p["precio"] || 0.0,
            "farmacia_nombre" => p["farmacia_nombre"] || "Farmacia no especificada"
          }
        end

        # --- 3️⃣ Generar el PDF ---
        ruta_pdf = PdfService.generar_pdf_receta(productos_pdf, paciente: paciente, medico: medico)

        { mensaje: "✅ PDF generado exitosamente con datos del REST", archivo: ruta_pdf }

      rescue => e
        { mensaje: "❌ Error al generar el PDF: #{e.message}", archivo: nil }
      end
    end
  end
end


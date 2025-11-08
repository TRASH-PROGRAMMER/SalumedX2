require 'prawn'
require 'prawn/table'

class PdfService
  def self.generar_pdf_receta(productos, paciente:, medico:)
    timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
    filename = "receta_#{paciente[:nombre].downcase.gsub(' ', '_')}_#{timestamp}.pdf"

    Prawn::Document.generate(filename, page_size: 'A4') do |pdf|
      logo_path = File.join(Dir.pwd, "public/images/logo_empresa.png")

      # --- LOGO ---
      if File.exist?(logo_path)
        pdf.image logo_path, width: 100, position: :center
        pdf.move_down 20
      end

      # --- ENCABEZADO ---
      pdf.text "Receta Médica - SaluuMedX", size: 20, style: :bold, align: :center
      pdf.move_down 10
      pdf.stroke_horizontal_rule
      pdf.move_down 20

      # --- DATOS DEL MÉDICO Y PACIENTE ---
      pdf.text "Médico: #{medico[:nombre]} (Licencia ##{medico[:licencia] || 'N/A'})", size: 12
      pdf.text "Paciente: #{paciente[:nombre]} (Cédula: #{paciente[:cedula] || 'N/A'})", size: 12
      pdf.text "Fecha: #{Time.now.strftime("%d/%m/%Y")}", size: 12
      pdf.move_down 20

      # --- TABLA DE PRODUCTOS ---
      data = [["Producto", "Presentación", "Cantidad", "Precio (USD)", "Farmacia"]] +
        productos.map do |p|
          [
            p["nombre"],
            p["presentacion"] || "-",
            p["cantidad"] || 1,
            sprintf("$%.2f", p["precio"].to_f),
            p["farmacia_nombre"] || "N/A"
          ]
        end

      pdf.table(data, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
        columns(3).align = :right
      end

      # --- TOTAL ---
      pdf.move_down 20
      total = productos.sum { |p| p["precio"].to_f * (p["cantidad"] || 1) }
      pdf.text "Total estimado: $#{sprintf("%.2f", total)}", size: 14, style: :bold

      # --- FIRMA Y PIE ---
      pdf.move_down 40
      pdf.text "Firma del médico: ____________________________", align: :right
      pdf.move_down 20
      pdf.text "Gracias por utilizar SaluuMedX", align: :center, size: 10, style: :italic
    end

    filename
  end
end

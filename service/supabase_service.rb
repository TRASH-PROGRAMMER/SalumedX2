# services/supabase_service.rb
require 'faraday'
require 'json'
require 'uri'
# Service para conexión a Supabase
class SupabaseService
  #inicializar conexión a Supabase
  def initialize(base_url, service_role_key)
    @base_url = base_url.gsub(/\/$/, '')
    @api_key = service_role_key
    @conn = Faraday.new(url: @base_url) do |f|
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end
  end

#obtener farmacias cercanas a un punto de referencia
  def get_farmacias_cercanas(lat, lng, radio_km)
    
    path = "/rest/v1/rpc/farmacias_cercanas"
    body = { lat: lat, lng: lng, radius_km: radio_km }.to_json
    response = @conn.post(path) do |req|
      # Definir el tipo de contenido y la clave de API
      req.headers['Content-Type'] = 'application/json'
      req.headers['apikey'] = @api_key
      req.headers['Authorization'] = "Bearer #{@api_key}"
      req.body = body
    end
    # Verificar si la respuesta es exitosa
    raise "Supabase error #{response.status}" unless response.success?
    JSON.parse(response.body)
  rescue Faraday::Error => e
    raise "Error al conectar a Supabase: #{e.message}"
  end

  # Obtener productos por farmacias acepta lista de ids de farmacias
  def get_productos_por_farmacias(farmacia_ids, nombre_producto=nil)
    # Usamos RPC o SQL a través de la REST API de Supabase
    ids = farmacia_ids.map(&:to_s).join(',')
    path = "/rest/v1/productos"
    params = { farmacia_id: "in.(#{ids})" }
    if nombre_producto && nombre_producto.strip != ''
      # búsqueda simple: ilike
      params[:nombre] = "ilike.%#{URI.encode_www_form_component(nombre_producto)}%"
    end
    # Ejecutamos la consulta
    response = @conn.get(path, params) do |req|
      req.headers['apikey'] = @api_key
      req.headers['Authorization'] = "Bearer #{@api_key}"
      req.params['select'] = '*'
    end
    # Verificar si la respuesta es exitosa
    raise "Supabase error #{response.status}" unless response.success?
    JSON.parse(response.body)
  rescue Faraday::Error => e
    raise "Error en get_productos_por_farmacias: #{e.message}"
  end

  # Obtener promociones por farmacias
  def get_promociones_por_farmacias(farmacia_ids)
    ids = farmacia_ids.map(&:to_s).join(',')
    path = "/rest/v1/promociones"
    params = { farmacia_id: "in.(#{ids})", vigente: "eq.true" }
    response = @conn.get(path, params) do |req|
      req.headers['apikey'] = @api_key
      req.headers['Authorization'] = "Bearer #{@api_key}"
    end
    raise "Supabase error #{response.status}" unless response.success?
    JSON.parse(response.body)
  rescue Faraday::Error => e
    raise "Error en get_promociones_por_farmacias: #{e.message}"
  end

  # Método general para ejecutar SQL vía endpoint 
  def query(sql)
    path = "/rest/v1/rpc/sql"
    resp = @conn.post(path) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['apikey'] = @api_key
      req.headers['Authorization'] = "Bearer #{@api_key}"
      req.body = { sql: sql }.to_json
    end
    JSON.parse(resp.body)
  end
end

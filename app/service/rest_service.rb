# service/rest_service.rb
require 'httparty'

class RestService
  include HTTParty
  attr_reader :base_url

  def initialize(base_url)
    @base_url = base_url
  end

  def get(path)
    self.class.get("#{base_url}#{path}", headers: default_headers)
  end

  def post(path, body)
    self.class.post("#{base_url}#{path}", body: body.to_json, headers: default_headers)
  end

  private

  def default_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end
end

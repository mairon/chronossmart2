# frozen_string_literal: true

# class responsible for check Whatsapp status
class Whatsapp
  class Status
    attr_reader :instance

    def initialize(instance:)
      @instance = instance
    end

    def connected?
      response = RestClient.get(url, headers)

      raise StandardError unless response.code == 200

      result = JSON.parse(response.body)

      result['instance']['status'] == 'connected'
    rescue StandardError, RestClient::Unauthorized
      false
    end

    private

    def headers
      { "Authorization": "Bearer #{ENV['WHATSAPP_API_TOKEN']}", "Content-Type": "application/json" }
    end

    def url
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/instance/#{instance}"
    end
  end
end

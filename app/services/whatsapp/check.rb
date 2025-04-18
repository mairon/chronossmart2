# frozen_string_literal: true

# class responsible for check if a telephone uses Whatsapp
<<<<<<< HEAD
class Whatsapp
=======
module Whatsapp
>>>>>>> origin/feature/add-whatsapp-service
  class Check
    attr_reader :instance, :telephone

    def initialize(instance:, telephone:)
      @instance = instance
      @telephone = telephone
    end

    def exists?
      response = RestClient.get(url, headers)

      raise StandardError unless response.code == 200

      result = JSON.parse(response.body)

      result['exists'] == true
    rescue StandardError, RestClient::Forbidden
      false
    end

    private

    def headers
      { "Authorization": "Bearer #{ENV['WHATSAPP_API_TOKEN']}", "Content-Type": "application/json" }
    end

    def url
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/instance/isOnWhatsApp/#{instance}?jid=#{telephone}"
    end
  end
end

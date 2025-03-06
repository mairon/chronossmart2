# frozen_string_literal: true

# class responsible for check Whatsapp status
module Whatsapp
  class Status
    attr_reader :token, :instance

    def initialize(token:, instance:)
      @token = token
      @instance = instance
    end

    def connected?
      response = RestClient.get(url, headers)

      result = JSON.parse(response.body)

      result['instance']['status'] == 'connected'
    rescue StandardError, RestClient::Unauthorized
      false
    end

    private

    def headers
      { "Authorization": "Bearer #{token}", "Content-Type": "application/json" }
    end

    def url
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/instance/#{instance}"
    end
  end
end

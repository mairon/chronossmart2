# frozen_string_literal: true

# class responsible for check Whatsapp status
module Whatsapp
  class Status
    attr_reader :host, :instance, :token

    def initialize(host:, instance:, token:)
      @host = host
      @instance = instance
      @token = token
    end

    def connected?
      response = RestClient.get(url, headers)

      result = JSON.parse(response.body)

      { message: result['instance']['status'] }
    rescue StandardError, RestClient::Unauthorized => error
      Rails.logger.error("#Message: #{error.message} - Backtrace: #{error.backtrace}")

      { message:  'Error to check status' }
    end

    private

    def headers
      { "Authorization": "Bearer #{token}", "Content-Type": "application/json" }
    end

    def url
      "https://#{host}/rest/instance/#{instance}"
    end
  end
end

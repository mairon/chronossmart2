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
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/instance/#{instance}"
    end
  end
end

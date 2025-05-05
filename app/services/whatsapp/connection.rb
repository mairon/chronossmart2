# frozen_string_literal: true

# class responsible for manage Whatsapp connection
module Whatsapp
  class Connection

    def initialize(host:, instance:, token:)
      @host = host
      @instance = instance
      @token = token
    end

    def disconnect
      response = RestClient.delete(disconnection_url, headers)

      result = JSON.parse(response.body)

      raise StandardError if result['error']

      { error: false, message: result['message'] }
    rescue StandardError, RestClient::Forbidden, RestClient::Unauthorized => error
      Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

      { error: true, message: 'Error logging out instance' }
    end

    private

    def headers
      { "Authorization": "Bearer #{token}", "Content-Type": "application/json" }
    end

    def disconnection_url
      "https://#{host}/rest/instance/#{instance}/logout"
    end
  end
end

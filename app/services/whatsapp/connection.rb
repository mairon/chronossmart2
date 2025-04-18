# frozen_string_literal: true

# class responsible for manage Whatsapp connection
module Whatsapp
  class Connection
    attr_reader :instance, :telephone, :token

    def initialize(token:, instance:, telephone: '')
      @instance = instance
      @telephone = telephone
      @token = token
    end

    def connect
      response = RestClient.get(connection_url, headers)

      result = JSON.parse(response.body)

      raise StandardError if result['error']

      { code: result['pairingCode'] }
    rescue StandardError, RestClient::Forbidden, RestClient::Unauthorized => error
      Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

      { code: '' }
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
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/instance/#{instance}/logout"
    end

    def connection_url
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/instance/pairingCode/#{instance}?phoneNumber=#{telephone}"
    end
  end
end

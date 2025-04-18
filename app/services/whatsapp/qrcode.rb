# frozen_string_literal: true

# class responsible for create Whatsapp QRCode
module Whatsapp
  class Qrcode
    NotAcceptable = Class.new(StandardError)

    attr_reader :instance, :token

    def initialize(token:, instance:)
      @instance = instance
      @token = token
    end

    def create
      response = RestClient.get(url, headers)

      result = JSON.parse(response.body)

      raise StandardError if result['error']

      unless result['qrcode'].start_with?('data:image/png;base64,')
        raise NotAcceptable, 'Invalid format of Base64'
      end

      { qrcode: result['qrcode'] }
    rescue StandardError, NotAcceptable, RestClient::Forbidden, RestClient::Unauthorized => error
      Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

      { error: 'Error to create QRCode' }
    end

    private

    def headers
      { "Authorization": "Bearer #{token}", "Content-Type": "application/json" }
    end

    def url
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/instance/qrcode_base64/#{instance}"
    end
  end
end

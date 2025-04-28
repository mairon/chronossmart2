# frozen_string_literal: true

# class responsible for check Whatsapp status
module Whatsapp
  class Message
    attr_reader :host, :token, :instance, :recipient, :text

    def initialize(params:)
      @host = params[:host]
      @token = params[:token]
      @instance = params[:instance]
      @recipient = params[:recipient]
      @text = params[:text]
    end

    def send
      response = RestClient.post(url, message, headers)

      result = JSON.parse(response.body)

      { message: result['message'] }
    rescue StandardError, RestClient::Unauthorized => error
      Rails.logger.error("#Message: #{error.message} - Backtrace: #{error.backtrace}")

      { message: "Error to send message to #{recipient}" }
    end

    def message
      {
        'messageData': {
          'to': recipient,
          'text': text
        }
      }.to_json
    end

    def headers
      { "Authorization": "Bearer #{token}", "Content-Type": "application/json" }
    end

    def url
      "https://#{host}/rest/sendMessage/#{instance}/text"
    end
  end
end

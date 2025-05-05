# frozen_string_literal: true

# class responsible for check Whatsapp status
module Whatsapp
  class Status
    attr_reader :host, :instance, :token


      @instance = instance
      @token = token
    end

    def connected?
      response = RestClient.get(url, headers)

<<<<<<< HEAD
      raise StandardError unless response.code == 200

      result = JSON.parse(response.body)

      result['instance']['status'] == 'connected'
    rescue StandardError, RestClient::Unauthorized
      false
=======
      result = JSON.parse(response.body)

      { message: result['instance']['status'] }
    rescue StandardError, RestClient::Unauthorized => error
      Rails.logger.error("#Message: #{error.message} - Backtrace: #{error.backtrace}")

      { message:  'Error to check status' }
>>>>>>> origin/feature/add-whatsapp-service
    end

    private

    def headers
<<<<<<< HEAD
      { "Authorization": "Bearer #{ENV['WHATSAPP_API_TOKEN']}", "Content-Type": "application/json" }
=======
      { "Authorization": "Bearer #{token}", "Content-Type": "application/json" }
>>>>>>> origin/feature/add-whatsapp-service
    end

    def url
      "https://#{host}/rest/instance/#{instance}"
    end
  end
end

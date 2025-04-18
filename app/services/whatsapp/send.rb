# frozen_string_literal: true

# class responsible for sending messages
<<<<<<< HEAD
class Whatsapp
=======
module Whatsapp
>>>>>>> origin/feature/add-whatsapp-service
  class Send
    attr_reader :telephone, :filepath, :title

    def initialize(telephone:, filepath:, title:)
      @telephone = telephone
      @title = title
      @filepath = Rails.root.join(filepath)
    end

    def execute
      response = RestClient.post(media_url, params.to_json, headers)

      result = JSON.parse(response.body)

      raise StandardError, result['message'] unless (result['error'] == false && response.code == 200)
    end

    private

    def headers
      { "Authorization": "Bearer #{ENV['WHATSAPP_API_TOKEN']}", "Content-Type": "application/json" }
    end

    def params
      { "messageData":
        { "to": "#{telephone}@s.whatsapp.net",
	        "base64": "data:application/pdf;base64,#{converted_file}",
          "fileName": title,
          "type": "document",
          "caption": title,
          "gifPlayback": false,
          "mimeType": "application/pdf" } }
    end

    def filename
      filepath.split.last.to_s
    end

    def media_url
      "https://#{ENV['WHATSAPP_API_HOST']}/rest/sendMessage/#{ENV['WHATSAPP_API_INSTANCE_KEY']}/mediaBase64"
    end

    def converted_file
      Base64
        .encode64(File.read(filepath))
        .gsub("\n", '')
      title = 'Any title'
    end
  end
end

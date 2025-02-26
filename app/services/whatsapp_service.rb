# frozen_string_literal: true

# class responsible for sending messages
class WhatsappService
  attr_reader :cellphone, :filepath

  def initialize(cellphone:, filepath:)
    @cellphone = cellphone
    @filepath = Rails.root.join(filepath)
  end

   #WhatsappService.new(cellphone: '5511991938027', filepath: 'spec/fixtures/test-documentation.pdf').send_pdf

  def send_pdf
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
      { "to": "#{cellphone}@s.whatsapp.net",
	      "base64": "data:application/pdf;base64,#{converted_file}",
        "fileName": filename,
        "type": "document",
        "caption": filename,
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
  end
end

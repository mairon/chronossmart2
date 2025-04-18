require 'rails_helper'

RSpec.describe Whatsapp::Qrcode do
  describe '#create' do
    it 'creates QR Code when to a Whatsapp instance when pass valid params' do
      qr_code = 'data:image/png;base64,iVBORw0KG='
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { { 'error' => false, 'qrcode' => qr_code }.to_json }
      allow(RestClient).to receive(:get) { response }

      result = described_class.new(token: token, instance: instance).create

      expected_result = { qrcode: qr_code }

      expect(result).to eq(expected_result)
    end

    it 'no validates when QR Code haven\'t format in Base64' do
      qr_code = 'data:image/png;base32,iVBORw0KG='
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { { 'error' => false, 'qrcode' => qr_code }.to_json }
      allow(RestClient).to receive(:get) { response }

      result = described_class.new(token: token, instance: instance).create

      expected_result = { error: 'Error to create QRCode' }

      expect(result).to eq(expected_result)
    end

    it 'no creates QR code when occurs generic errors' do
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(RestClient).to receive(:get) { raise StandardError }

      result = described_class.new(token: token, instance: instance).create

      expected_result = { error: 'Error to create QRCode' }

      expect(result).to eq(expected_result)
    end

    it 'no creates QR code when isn\'t phroibited' do
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(RestClient).to receive(:get) { raise RestClient::Forbidden }

      result = described_class.new(token: token, instance: instance).create

      expected_result = { error: 'Error to create QRCode' }

      expect(result).to eq(expected_result)
    end

    it 'no creates QR code when isn\'t authorized' do
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(RestClient).to receive(:get) { raise RestClient::Unauthorized }

      result = described_class.new(token: token, instance: instance).create

      expected_result = { error: 'Error to create QRCode' }

      expect(result).to eq(expected_result)
    end
  end
end

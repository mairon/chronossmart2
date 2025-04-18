require 'rails_helper'

RSpec.describe Whatsapp::Connection do
  describe '#connect' do
    it 'connects with a Whatsapp instance when pass valid params' do
      pairing_code = 'ABCXPTO1'
      token = 'any token'
      instance = 'any instance'
      telephone = '55912345678'

      response = double

      allow(response).to receive(:body) { { 'error' => false, 'pairingCode' => pairing_code }.to_json }
      allow(RestClient).to receive(:get) { response }

      result = described_class
        .new(token: token, instance: instance, telephone: telephone)
        .connect

      expected_result = { code: pairing_code }

      expect(result).to eq(expected_result)
    end

    it 'no connects with a Whatsapp instance when occurs generic errors' do
      token = 'any token'
      instance = 'any instance'
      telephone = '55912345678'

      response = double

      allow(response).to receive(:body) { raise StandardError }
      allow(RestClient).to receive(:get) { response }

      result = described_class
        .new(token: token, instance: instance, telephone: telephone)
        .connect

      expected_result = { code: '' }

      expect(result).to eq(expected_result)
    end

    it 'no connects with a Whatsapp instance when is phrobited' do
      token = 'any token'
      instance = 'any instance'
      telephone = '55912345678'

      response = double

      allow(response).to receive(:body) { raise RestClient::Forbidden }
      allow(RestClient).to receive(:get) { response }

      result = described_class
        .new(token: token, instance: instance, telephone: telephone)
        .connect

      expected_result = { code: '' }

      expect(result).to eq(expected_result)
    end

    it 'no connects with a Whatsapp instance when is unauthorized' do
      token = 'any token'
      instance = 'any instance'
      telephone = '55912345678'

      response = double

      allow(response).to receive(:body) { raise RestClient::Unauthorized }
      allow(RestClient).to receive(:get) { response }

      result = described_class
        .new(token: token, instance: instance, telephone: telephone)
        .connect

      expected_result = { code: '' }

      expect(result).to eq(expected_result)
    end
  end

    describe '#disconnect' do
    it 'disconnects with a Whatsapp instance when pass valid params' do
      message = 'Instance logged out'
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { { 'error' => false, 'message' => message }.to_json }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(token: token, instance: instance).disconnect

      expected_result = { error: false, message: message }

      expect(result).to eq(expected_result)
    end

    it 'no disconnects with a Whatsapp instance when occurs generic errors' do
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { raise StandardError }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(token: token, instance: instance).disconnect

      expected_result = { error: true, message: 'Error logging out instance' }

      expect(result).to eq(expected_result)
    end

    it 'no disconnects with a Whatsapp instance when is phrobited' do
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { raise RestClient::Forbidden }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(token: token, instance: instance).disconnect

      expected_result = { error: true, message: 'Error logging out instance' }

      expect(result).to eq(expected_result)
    end

    it 'no disconnects with a Whatsapp instance when is unauthorized' do
      token = 'any token'
      instance = 'any instance'
      telephone = '55912345678'

      response = double

      allow(response).to receive(:body) { raise RestClient::Unauthorized }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(token: token, instance: instance).disconnect

      expected_result = { error: true, message: 'Error logging out instance' }

      expect(result).to eq(expected_result)
    end
  end
end

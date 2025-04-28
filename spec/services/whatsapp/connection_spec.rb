require 'rails_helper'

RSpec.describe Whatsapp::Connection do
    describe '#disconnect' do
    it 'disconnects with a Whatsapp instance when pass valid params' do
      message = 'Instance logged out'
      host = 'example.com'
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { { 'error' => false, 'message' => message }.to_json }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(host: host, instance: instance, token: token).disconnect

      expected_result = { error: false, message: message }

      expect(result).to eq(expected_result)
    end

    it 'no disconnects with a Whatsapp instance when occurs generic errors' do
      host = 'example.com'
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { raise StandardError }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(host: host, instance: instance, token: token).disconnect

      expected_result = { error: true, message: 'Error logging out instance' }

      expect(result).to eq(expected_result)
    end

    it 'no disconnects with a Whatsapp instance when is phrobited' do
      host = 'example.com'
      token = 'any token'
      instance = 'any instance'

      response = double

      allow(response).to receive(:body) { raise RestClient::Forbidden }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(host: host, instance: instance, token: token).disconnect

      expected_result = { error: true, message: 'Error logging out instance' }

      expect(result).to eq(expected_result)
    end

    it 'no disconnects with a Whatsapp instance when is unauthorized' do
      host = 'example.com'
      token = 'any token'
      instance = 'any instance'
      telephone = '55912345678'

      response = double

      allow(response).to receive(:body) { raise RestClient::Unauthorized }
      allow(RestClient).to receive(:delete) { response }

      result = described_class.new(host: host, instance: instance, token: token).disconnect

      expected_result = { error: true, message: 'Error logging out instance' }

      expect(result).to eq(expected_result)
    end
  end
end

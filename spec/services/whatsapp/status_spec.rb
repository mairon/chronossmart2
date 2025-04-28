require 'rails_helper'

RSpec.describe Whatsapp::Status do
  describe '#connected?' do
    it 'returns \'true\' when instance is connected' do
      host = 'example.com'
      token = '123abc'
      instance = 'megastart-123abc'
      body = "{\"error\":false,\"message\":\"Instance status fetched\",\"instance\":{\"key\":\"#{instance}\",\"status\":\"connected\",\"user\":{\"id\":\"595986287555:57@s.whatsapp.net\",\"lid\":\"100764227739678:57@lid\",\"name\":\"Mairon Brasil\"}}}"

      response = double

      allow(response).to receive(:body) { body }
      allow(RestClient).to receive(:get) { response }

      result = described_class.new(host: host, instance: instance, token: token).connected?

      expected_result = { message: 'connected' }

      expect(result).to eq(expected_result)
    end

    it 'returns \'false\' when instance isn\'t connected' do
      host = 'example.com'
      token = '123abc'
      instance = 'megastart-123abc'
      body = "{\"error\":false,\"message\":\"Instance status fetched\",\"instance\":{\"key\":\"#{instance}\",\"status\":\"disconnected\",\"user\":{\"id\":\"595986287555:57@s.whatsapp.net\",\"lid\":\"100764227739678:57@lid\",\"name\":\"Mairon Brasil\"}}}"

      response = double

      allow(response).to receive(:body) { body }
      allow(RestClient).to receive(:get) { response }

      result = described_class.new(host: host, instance: instance, token: token).connected?

      expected_result = { message: 'disconnected' }

      expect(result).to eq(expected_result)
    end

    it 'returns \'false\' when occurs errors' do
      host = 'example.com'
      token = '123abc'
      instance = 'megastart-123abc'

      allow(RestClient).to receive(:get) { raise RestClient::Unauthorized }

      result = described_class.new(host: host, instance: instance, token: token).connected?

      expected_result = { message: 'Error to check status' }

      expect(result).to eq(expected_result)
    end
  end
end

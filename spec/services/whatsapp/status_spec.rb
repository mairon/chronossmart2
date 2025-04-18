require 'rails_helper'

RSpec.describe Whatsapp::Status do
  describe '#connected?' do
    it 'returns \'true\' when instance is connected' do
<<<<<<< HEAD
=======
      token = '123abc'
>>>>>>> origin/feature/add-whatsapp-service
      instance = 'megastart-123abc'
      body = "{\"error\":false,\"message\":\"Instance status fetched\",\"instance\":{\"key\":\"#{instance}\",\"status\":\"connected\",\"user\":{\"id\":\"595986287555:57@s.whatsapp.net\",\"lid\":\"100764227739678:57@lid\",\"name\":\"Mairon Brasil\"}}}"

      response = double

      allow(response).to receive(:body) { body }
      allow(RestClient).to receive(:get) { response }

<<<<<<< HEAD
      result = described_class.new(instance: instance).connected?

      expect(result).to eq(true)
    end

    it 'returns \'false\' when instance isn\'t connected' do
=======
      result = described_class.new(token: token, instance: instance).connected?

      expected_result = { message: 'connected' }

      expect(result).to eq(expected_result)
    end

    it 'returns \'false\' when instance isn\'t connected' do
      token = '123abc'
>>>>>>> origin/feature/add-whatsapp-service
      instance = 'megastart-123abc'
      body = "{\"error\":false,\"message\":\"Instance status fetched\",\"instance\":{\"key\":\"#{instance}\",\"status\":\"disconnected\",\"user\":{\"id\":\"595986287555:57@s.whatsapp.net\",\"lid\":\"100764227739678:57@lid\",\"name\":\"Mairon Brasil\"}}}"

      response = double

      allow(response).to receive(:body) { body }
      allow(RestClient).to receive(:get) { response }

<<<<<<< HEAD
      result = described_class.new(instance: instance).connected?

      expect(result).to eq(false)
    end

    it 'returns \'false\' when occurs errors' do
=======
      result = described_class.new(token: token, instance: instance).connected?

      expected_result = { message: 'disconnected' }

      expect(result).to eq(expected_result)
    end

    it 'returns \'false\' when occurs errors' do
      token = '123abc'
>>>>>>> origin/feature/add-whatsapp-service
      instance = 'megastart-123abc'

      allow(RestClient).to receive(:get) { raise RestClient::Unauthorized }

<<<<<<< HEAD
      result = described_class.new(instance: instance).connected?

      expect(result).to eq(false)
=======
      result = described_class.new(token: token, instance: instance).connected?

      expected_result = { message: 'Error to check status' }

      expect(result).to eq(expected_result)
>>>>>>> origin/feature/add-whatsapp-service
    end
  end
end

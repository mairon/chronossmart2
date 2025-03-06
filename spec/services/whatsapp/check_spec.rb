require 'rails_helper'

RSpec.describe Whatsapp::Check do
  describe '#exists?' do
    it 'returns \'true\' when telephone exists' do
      instance = 'megastart-123abc'
      telephone = '5511912345678'
      body = "{\"exists\":true,\"jid\":\"#{telephone}@s.whatsapp.net\",\"lid\":\"69411016859767@lid\",\"isBusiness\":false,\"isEnterprise\":false,\"status\":\"\",\"disappearing_mode\":{\"timestamp\":\"0\",\"duration\":\"0\"}}"

      response = double

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { body }
      allow(RestClient).to receive(:get) { response }

      result = described_class.new(instance: instance, telephone: telephone).exists?

      expect(result).to eq(true)
    end

    it 'returns \'true\' when telephone no exists' do
      instance = 'megastart-123abc'
      telephone = '5511912345678'
      body = "{\"exists\":false,\"jid\":\"#{telephone}@s.whatsapp.net\",\"lid\":\"69411016859767@lid\",\"isBusiness\":false,\"isEnterprise\":false,\"status\":\"\",\"disappearing_mode\":{\"timestamp\":\"0\",\"duration\":\"0\"}}"

      response = double

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { body }
      allow(RestClient).to receive(:get) { response }

      result = described_class.new(instance: instance, telephone: telephone).exists?

      expect(result).to eq(false)
    end

    it 'returns \'false\' when occurs errors' do
      instance = 'megastart-123abc'
      telephone = '5511912345678'

      allow(RestClient).to receive(:get) { raise RestClient::Forbidden }

      result = described_class.new(instance: instance, telephone: telephone).exists?

      expect(result).to eq(false)
    end
  end
end

require 'rails_helper'

RSpec.describe Whatsapp::Message do
  describe '#send' do
    context 'when pass correct params' do
      it 'returns success message' do
        success_message = 'Message sent'

        response = double

        allow(response).to receive(:body) { { 'message' => success_message }.to_json }
        allow(response).to receive(:status) { 200 }
        allow(RestClient).to receive(:post) { response }

        params = { 'host': 'exemplo.host.com',
                   'token': 'abc12345',
                   'instance': 'instance-abc12345',
                   'recipient': '5511999999999',
                   'text': 'Teste de envio' }

        result = described_class.new(params: params).send

        expected_result = { message: success_message }

        expect(result).to eq(expected_result)
      end
    end

    context 'when pass incorrect params' do
      it 'returns error message' do
        allow(RestClient).to receive(:post) { raise RestClient::Unauthorized }

        error_message = 'Error to send message to 5511999999999'

        params = { 'host': 'incorrect_host.com',
                   'token': 'incorrect_token',
                   'instance': 'incorrect_instance',
                   'recipient': '5511999999999',
                   'text': 'Teste de envio' }

        result = described_class.new(params: params).send

        expected_result = { message: error_message }

        expect(result).to eq(expected_result)
      end
    end

    context 'when occurs generic errors' do
      it 'returns error message' do
        success_message = 'Message sent'

        error_message = 'Error to send message to 5511999999999'

        response = double

        allow(response).to receive(:body) { { 'message' => success_message }.to_json }
        allow(response).to receive(:status) { 200 }
        allow(RestClient).to receive(:post) { response }
        allow(JSON).to receive(:parse) { raise StandardError }

        params = { 'host': 'exemplo.host.com',
                   'token': 'abc12345',
                   'instance': 'instance-abc12345',
                   'recipient': '5511999999999',
                   'text': 'Teste de envio' }

        result = described_class.new(params: params).send

        expected_result = { message: error_message }

        expect(result).to eq(expected_result)
      end
    end
  end
end

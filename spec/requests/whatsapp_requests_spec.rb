require 'rails_helper'

RSpec.describe WhatsappsController, type: :request do
  describe 'GET actions' do
    describe '#status' do
      context 'when Whatsapp is connected' do
        it 'returns connected message' do
          result = { message: 'connected' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { result }

          get '/whatsapp/status', params: params

          expected_result = result.to_json

          expect(response.body).to eq(expected_result)
        end

        it 'returns HTTP status 200' do
          result = { message: 'connected' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { result }

          get '/whatsapp/status', params: params

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when Whatsapp is disconnected' do
        it 'returns connected message' do
          result = { message: 'disconnected' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { result }

          get '/whatsapp/status', params: params

          expected_result = result.to_json

          expect(response.body).to eq(expected_result)
        end

        it 'returns HTTP status 200' do
          result = { message: 'disconnected' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { result }

          get '/whatsapp/status', params: params

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when occurs generic errors' do
        it 'returns connected message' do
          result = { message: 'disconnected' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { raise StandardError }

          get '/whatsapp/status', params: params

          expected_result = {}.to_json

          expect(response.body).to eq(expected_result)
        end

        it 'returns HTTP status 500' do
          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { raise StandardError }

          get '/whatsapp/status', params: params

          expect(response).to have_http_status(:internal_server_error)
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe WhatsappsController, type: :request do
  describe 'GET actions' do
    describe '#logout' do
      context 'when pass valid params' do
        it 'disconnects Whatsapp instance' do
          result = { 'error' => false, 'message' => 'Instance logged out' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Connection).to receive_message_chain(:new, :disconnect) { result }

          get '/whatsapp/logout', params: params

          expected_result = result.to_json

          expect(response.body).to eq(expected_result)
        end

        it 'returns HTTP status 200' do
          result = { 'error' => false, 'message' => 'Instance logged out' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Connection).to receive_message_chain(:new, :disconnect) { result }

          get '/whatsapp/logout', params: params

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when occurs generic errors' do
        it 'no disconnects Whatsapp instance' do
          result = { 'error' => true, 'message' => 'Error logging out instance' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Connection).to receive_message_chain(:new, :disconnect) { raise StandardError }

          get '/whatsapp/logout', params: params

          expected_result = '{}'

          expect(response.body).to eq(expected_result)
        end

        it 'returns HTTP status 500' do
          result = { 'error' => true, 'message' => 'Error logging out instance' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Connection).to receive_message_chain(:new, :disconnect) { raise StandardError }

          get '/whatsapp/logout', params: params

          expect(response).to have_http_status(:internal_server_error)
        end
      end
    end

    describe '#create_qrcode' do
      context 'when pass valid params' do
        it 'creates QR Code' do
          result = { qrcode: 'data:image/png;base64,iVBORw0KG=' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Qrcode).to receive_message_chain(:new, :create) { result }

          get '/whatsapp/qrcode', params: params

          expected_result = result.to_json

          expect(response.body).to eq(expected_result)
        end

        it 'returns HTTP status 200' do
          result = { qrcode: 'data:image/png;base64,iVBORw0KG=' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Qrcode).to receive_message_chain(:new, :create) { result }

          get '/whatsapp/qrcode', params: params
                                                                                                             expect(response).to have_http_status(:ok)
        end
      end

      context 'when occurs generic errors' do
        it 'no creates QR Code' do
          result = { error: 'Error to create QRCode' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Qrcode).to receive_message_chain(:new, :create) { raise StandardError }

          get '/whatsapp/qrcode', params: params

          expected_result = '{}'

          expect(response.body).to eq(expected_result)
        end

        it 'returns HTTP status 500' do
          result = { error: 'Error to create QRCode' }

          params = { token: 'abc1234', instance: 'mega-abc1234' }

          allow(Whatsapp::Qrcode).to receive_message_chain(:new, :create) { raise StandardError }

          get '/whatsapp/qrcode', params: params
                                                                                                             expect(response).to have_http_status(:internal_server_error)
        end
      end
    end

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

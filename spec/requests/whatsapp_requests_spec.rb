require 'rails_helper'

RSpec.describe WhatsappsController, type: :request do
  describe 'POST actions' do
    describe '#send_message' do
      context 'when pass valid params' do
        it 'returns success message' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          message = { message: 'Message sent', success: true }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { message }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          success_message = '¡Prueba enviada exitosamente!'

          post '/whatsapp/send_message', params

          expect(flash[:notice]).to eq(success_message)
        end

        it 'redirects to device page' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          message = { message: 'Message sent', success: true }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { message }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          post '/whatsapp/send_message', params

          expect(response).to redirect_to(device_path(device.id))
        end
      end

      context 'when pass invalid params' do
        it 'returns error message' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          message = { message: 'Error to send message to 5511999999999', success: false }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { message }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': nil }

          error_message = '¡Error al enviar el mensaje!'

          post '/whatsapp/send_message', params

          expect(flash[:alert]).to eq(error_message)
        end

        it 'redirects to device page' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          message = { message: 'Message sent', success: true }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { message }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          post '/whatsapp/send_message', params

          expect(response).to redirect_to(device_path(device.id))
        end
      end

      context 'when device isn\'t found' do
        it 'returns error message' do
          device_id = '99999999999'

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          error_message = '¡Dispositivo no encontrado!'

          post '/whatsapp/send_message', params

          expect(flash[:alert]).to eq(error_message)
        end

        it 'redirects to devices page' do
          device_id = '99999999999'

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          error_message = 'Device não encontrado!'

          post '/whatsapp/send_message', params

          expect(response).to redirect_to(devices_path)
        end
      end

      context 'when device isn\'t authorized' do
        it 'returns error message' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { raise RestClient::Unauthorized }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          error_message = '¡Error al enviar el mensaje!'

          post '/whatsapp/send_message', params

          expect(flash[:alert]).to eq(error_message)
        end

        it 'redirects to device page' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          message = { message: 'Message sent', success: true }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { message }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          post '/whatsapp/send_message', params

          expect(response).to redirect_to(device_path(device.id))
        end
      end

      context 'when occurs generic errors' do
        it 'returns error message' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { raise StandardError }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          error_message = '¡Error al enviar el mensaje!'

          post '/whatsapp/send_message', params

          expect(flash[:alert]).to eq(error_message)
        end

        it 'redirects to device page' do
          device_id = '1'

          device = double

          allow(device).to receive(:id) { 1 }
          allow(device).to receive(:nome) { 'Comercial' }
          allow(device).to receive(:host) { 'exemplo.host.com' }
          allow(device).to receive(:instance_key) { 'instance-abc12345' }
          allow(device).to receive(:token) { 'abc12345' }
          allow(Device).to receive(:where).with(id: device_id) { [device] }

          message = { message: 'Message sent', success: true }

          allow(Whatsapp::Message).to receive_message_chain(:new, :send) { message }

          params = { 'device_id': device_id, 'recipient': '5511999999999', 'text': 'Teste de envio' }

          post '/whatsapp/send_message', params

          expect(response).to redirect_to(device_path(device.id))
        end
      end
    end
  end

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
  end
end

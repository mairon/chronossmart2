require 'rails_helper'

RSpec.describe WhatsappHelper, type: :helper do
  describe '#connected_whatsapp?' do
    it 'returns true if Whatsapp is connected' do
      host = 'example.com'
      token = 'ABC1234'
      instance = 'inst-ABC1234'

      allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { { message: 'connected' } }

      result = helper.connected_whatsapp?(host: host, instance: instance, token: token)

      expect(result).to eq(true)
    end

    it 'returns false if Whatsapp is disconnected' do
      host = 'example.com'
      token = 'ABC1234'
      instance = 'inst-ABC1234'

      allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { { message: 'disconnected' } }

      result = helper.connected_whatsapp?(host: host, instance: instance, token: token)

      expect(result).to eq(false)
    end
  end
end

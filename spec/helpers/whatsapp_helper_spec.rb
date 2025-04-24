require 'rails_helper'

RSpec.describe WhatsappHelper, type: :helper do
  describe '#connected_whatsapp?' do
    it 'returns true if Whatsapp is connected' do
      token = 'ABC1234'
      instance = 'inst-ABC1234'

      allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { { message: 'connected' } }

      result = helper.connected_whatsapp?(token: token, instance: instance)

      expect(result).to eq(true)
    end

    it 'returns false if Whatsapp is disconnected' do
      token = 'ABC1234'
      instance = 'inst-ABC1234'

      allow(Whatsapp::Status).to receive_message_chain(:new, :connected?) { { message: 'disconnected' } }

      result = helper.connected_whatsapp?(token: token, instance: instance)

      expect(result).to eq(false)
    end
  end
end

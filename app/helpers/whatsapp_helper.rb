# frozen_string_literal: true

module WhatsappHelper
  def connected_whatsapp?(token:, instance:)
    result = Whatsapp::Status
      .new(token: token, instance: instance)
      .connected?

    result[:message] == 'connected'
  end
end

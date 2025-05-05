# frozen_string_literal: true

module WhatsappHelper
  def connected_whatsapp?(host:, instance:, token:)
    result = Whatsapp::Status
      .new(host: host, instance: instance, token: token)
      .connected?

    result[:message] == 'connected'
  end
end

# frozen_string_literal: true

# class responsible for the whatsapps controller
class WhatsappsController < ApplicationController
  def create_qrcode
    result = Whatsapp::Qrcode.new(token: params['token'], instance: params['instance']).create

    render json: result, status: :ok
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    render json: {}, status: :internal_server_error
  end

  def send_message
    result = Whatsapp::Message.new(params: send_params).send

    raise MessageSendError unless result[:success]

    redirect_to device_path(device.id), notice: t('successes.messages.test_sent_successfully')
  rescue StandardError, MessageSendError, DeviceFindError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to error_path(error), alert: error_message(error)
  end

  def logout
    result = Whatsapp::Connection.new(token: params['token'], instance: params['instance']).disconnect

    render json: result, status: :ok
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    render json: {}, status: :internal_server_error
  end

  private

  def error_path(error)
    error.is_a?(DeviceFindError) ? devices_path : device_path(device.id)
  end

  def error_message(error)
    error.is_a?(DeviceFindError) ?
      t('errors.messages.device_not_found') :
      t('errors.messages.message_send_failed')
  end

  def device
    @device ||= Device.where(id: params['device_id']).try(:first)
  end

  def send_params
    raise DeviceFindError unless device

    params.merge(
      'host' => device.host, 'token' => device.token, 'instance' => device.instance_key
    )
  end
end

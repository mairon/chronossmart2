# frozen_string_literal: true

# class responsible for the whatsapps controller
class WhatsappsController < ApplicationController
  def status
    result = Whatsapp::Status.new(token: params[:token], instance: params[:instance]).connected?

    render json: result, status: :ok
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    render json: {}, status: :internal_server_error
  end

  def create_qrcode
    result = Whatsapp::Qrcode.new(token: params[:token], instance: params[:instance]).create

    render json: result, status: :ok
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    render json: {}, status: :internal_server_error
  end

  def logout
    result = Whatsapp::Connection.new(token: params[:token], instance: params[:instance]).disconnect

    render json: result, status: :ok
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    render json: {}, status: :internal_server_error
  end
end

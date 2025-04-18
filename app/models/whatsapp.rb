# frozen_string_literal: true

# class responsible for manage Whatsapp instances
class Whatsapp < ActiveRecord::Base
  validates :instance,
            :token,
            :status,
            presence: true

  validates :instance,
            uniqueness: true
end

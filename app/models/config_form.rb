class ConfigForm < ActiveRecord::Base
	belongs_to :unidade
	belongs_to :terminal
  validates :nome, :unidade_id, :terminal_id, presence: true
end

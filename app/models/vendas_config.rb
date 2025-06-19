class VendasConfig < ActiveRecord::Base
	belongs_to :persona
	belongs_to :unidade

	def self.cached_config_for_unidade(unidade_id)
	  Rails.cache.fetch("vendas_config_#{unidade_id}", expires_in: 5.minutes) do
	    where(unidade_id: unidade_id).order(id: :desc).first
	  end
	end
end

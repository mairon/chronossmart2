class SolicitudeCredito < ActiveRecord::Base
	belongs_to :plano_venda
	has_many :solicitude_credito_autorizacoes, :dependent => :destroy
end

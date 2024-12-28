class ContratoCusto < ActiveRecord::Base
	belongs_to :cargo
	belongs_to :persona
	belongs_to :contrato
	has_many :contrato_custo_dts, dependent: :destroy

end

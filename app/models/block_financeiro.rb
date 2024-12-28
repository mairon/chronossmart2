class BlockFinanceiro < ActiveRecord::Base
	belongs_to :usuario
	validates_uniqueness_of :periodo, message: "Periodo ja cadastrado."
end

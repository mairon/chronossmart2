class OperacaoFiscal < ActiveRecord::Base
	validates :tipo, :cfop, :nome, presence: true
	validates_uniqueness_of :cfop, message: " ja cadastrado."


end

class NotaCreditosDoc < ActiveRecord::Base
	belongs_to :nota_credito

	validates_presence_of :documento_numero_01, :documento_numero_02, :documento_numero, :cota, :vencimento
	validates_numericality_of :valor_guarani, :greater_than => 0	
end

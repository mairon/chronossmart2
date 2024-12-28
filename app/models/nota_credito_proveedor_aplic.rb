class NotaCreditoProveedorAplic < ActiveRecord::Base
	belongs_to :nota_credito_proveedor

	validates_numericality_of :valor_dolar, :greater_than => 0	
	validates_presence_of :documento_numero_01,:documento_numero_02,:documento_numero,:cota

end

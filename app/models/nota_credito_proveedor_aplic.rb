class NotaCreditoProveedorAplic < ActiveRecord::Base
	belongs_to :nota_credito_proveedor

	validates_presence_of :documento_numero_01,:documento_numero_02,:documento_numero,:cota

end

class NcProveedorFatura < ActiveRecord::Base
  belongs_to :nota_credito_proveedors

  validates_presence_of :persona_id,:documento_numero_01,:documento_numero_02,:documento_numero 

end

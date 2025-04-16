class NotaCreditoProveedor < ActiveRecord::Base
	#audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :nc_proveedor_fatura, :dependent => :destroy
  has_many :nota_credito_proveedor_produto, :dependent => :destroy
  has_many :nota_credito_proveedor_aplics, :dependent => :destroy

  validates_presence_of :persona_id

end
 
class ComprasPedido < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.compra_id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to  :produto
	belongs_to :pedido_compra
  has_many :compras_produtos, dependent: :destroy

end

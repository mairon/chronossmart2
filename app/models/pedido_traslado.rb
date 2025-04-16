class PedidoTraslado < ActiveRecord::Base
  has_many :pedido_traslado_docs, dependent: :destroy
  has_many :ordem_cargas, dependent: :destroy
  belongs_to :persona
end

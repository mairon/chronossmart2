class PedidoCompraProduto < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.pedido_compra_id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  belongs_to :pedido_compra
  belongs_to :produto
  belongs_to :clase
  validates_presence_of :produto_id,:produto_nome,:quantidade

  before_save :calc

  def calc
  	if self.moeda.to_i == 0
  		self.unitario_guarani = (self.unitario_dolar.to_f * pedido_compra.cotacao.to_f)
  		self.unitario_real = (self.unitario_guarani.to_f / pedido_compra.cotacao_real.to_f)

  		self.total_guarani = (self.total_dolar.to_f * pedido_compra.cotacao.to_f)
  		self.total_real = (self.total_guarani.to_f / pedido_compra.cotacao_real.to_f)
  	elsif self.moeda.to_i == 1
  		self.unitario_dolar = (self.unitario_guarani.to_f / pedido_compra.cotacao.to_f)
  		self.unitario_real = (self.unitario_guarani.to_f / pedido_compra.cotacao_real.to_f)

  		self.total_dolar = (self.total_guarani.to_f / pedido_compra.cotacao.to_f)
  		self.total_real = (self.total_guarani.to_f / pedido_compra.cotacao_real.to_f)

  	elsif self.moeda.to_i == 2
  		self.unitario_guarani = (self.unitario_real.to_f * pedido_compra.cotacao_real.to_f)
  		self.unitario_dolar = (self.unitario_guarani.to_f / pedido_compra.cotacao.to_f)

  		self.total_guarani = (self.total_real.to_f * pedido_compra.cotacao_real.to_f)
  		self.total_dolar = (self.total_guarani.to_f / pedido_compra.cotacao.to_f)
  	end
	end
end

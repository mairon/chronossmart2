class PedidoCompraFinanca < ActiveRecord::Base
	belongs_to :pedido_compra
  before_save :calc

  def calc
  	if pedido_compra.moeda.to_i == 0
  		self.valor_gs = (self.valor_us.to_f * pedido_compra.cotacao.to_f)
  		self.valor_rs = (self.valor_gs.to_f / pedido_compra.cotacao_real.to_f)
  	elsif pedido_compra.moeda.to_i == 1
  		self.valor_us = (self.valor_gs.to_f / pedido_compra.cotacao.to_f)
  		self.valor_rs = (self.valor_gs.to_f / pedido_compra.cotacao_real.to_f)
  	elsif pedido_compra.moeda.to_i == 2
  		self.valor_gs = (self.valor_rs.to_f * pedido_compra.cotacao_real.to_f)
  		self.valor_us = (self.valor_gs.to_f / pedido_compra.cotacao.to_f)
  	end
	end

end

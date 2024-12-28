class OrdemServProd < ActiveRecord::Base
  belongs_to :ordem_serv
  belongs_to :deposito
  belongs_to :produto

  #before_save :calc

  def calc
  	tb = ProdutosTabelaPreco.where(produto_id: self.produto_id).last
  	self.valor_us = tb.preco_1_us.to_f
  	self.valor_gs = tb.preco_1_gs.to_f
  	self.valor_rs = tb.preco_1_rs.to_f
  end
end

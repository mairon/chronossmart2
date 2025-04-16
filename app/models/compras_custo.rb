class ComprasCusto < ActiveRecord::Base
  belongs_to :compra
  belongs_to :centro_custo
  belongs_to :unidade
  belongs_to :rubro
  belongs_to :rodado
  belongs_to :ordem_carga
  belongs_to :pedido_traslado
  belongs_to :plano_de_conta
  before_save :finds

  def finds
	  if compra.moeda == 0
	    self.valor_gs = self.valor_us.to_f * compra.cotacao.to_f
	    #self.valor_rs = self.valor_us.to_f / compra.cotacao_rs_us.to_f
	  elsif compra.moeda == 1
	    self.valor_us = self.valor_gs.to_f / compra.cotacao.to_f
	    #self.valor_rs = self.valor_gs.to_f / compra.cotacao_real.to_f
	  else
	    #self.valor_gs = self.valor_rs.to_f * compra.cotacao_real.to_f
	    #self.valor_us = self.valor_rs.to_f / compra.cotacao_rs_us.to_f
	  end
	end
end

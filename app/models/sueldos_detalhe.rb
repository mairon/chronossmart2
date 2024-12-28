class SueldosDetalhe < ActiveRecord::Base
  belongs_to :sueldo
  before_save :finds
  def finds
  	if self.descricao == ''
  		self.descricao = 'PAGO' + ' ' + self.documento_numero_01 + '-' + self.documento_numero_02 + '-' + self.documento_numero
  	end

    @rubro = Rubro.find_by_id(self.rubro_id);
    self.rubro_nome = @rubro.descricao.to_s unless self.rubro_id.blank?
    	last_cotacao = Moeda.all

    if self.moeda.to_i == 0
    	self.credito_gs = (self.credito_us.to_f * last_cotacao.last.dolar_venda.to_f)
    	self.debito_gs  = (self.debito_us.to_f * last_cotacao.last.dolar_venda.to_f)
    elsif self.moeda.to_i == 1
    	self.credito_us = (self.credito_gs.to_f / last_cotacao.last.dolar_venda.to_f)
    	self.debito_us = (self.debito_gs.to_f / last_cotacao.last.dolar_venda.to_f)
    end
  end

end

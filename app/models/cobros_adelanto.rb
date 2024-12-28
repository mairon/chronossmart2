class CobrosAdelanto < ActiveRecord::Base
    audit(:create, :update, :destroy) { |model, user, action| "|#{model.cobro_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }

	belongs_to :cobro

  	validates_presence_of :persona_id, :cota, :documento_numero, :documento_numero_01, :documento_numero_02

    before_save :calcs
    def calcs
	    if self.liquidacao == 0
	        if cobro.moeda == 0
	           self.valor_gs   = self.valor_us.to_f * cobro.cotacao.to_i
	        elsif cobro.moeda == 1
	           self.valor_us   = self.valor_gs.to_f / valor.cotacao.to_i
	        else
	           self.valor_gs   = self.valor_rs.to_f * valor.cotacao_real.to_i
	           self.valor_us   = self.valor_gs.to_f / cobro.cotacao.to_i
	        end
	    end
    end

end

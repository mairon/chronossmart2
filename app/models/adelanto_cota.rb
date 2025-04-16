class AdelantoCota < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.adelanto_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
	belongs_to :adelanto
	#validate :valid_cotas, :on => :update


  def valid_cotas
      if adelanto.moeda == 0
          saldo = AdelantoCota.sum('valor_us',:conditions => ["adelanto_id = ? and id != #{self.id}",self.adelanto_id])
          if (saldo.to_f + self.valor_us.to_f).round(2) > adelanto.valor_dolar.to_f.round(2)
              errors[:base] << ( "Valor Ultrassa lo total de lo Documento" )
          end
      elsif adelanto.moeda == 1
          saldo = AdelantoCota.sum('valor_gs',:conditions => ["adelanto_id = ? and id != #{self.id}",self.adelanto_id])
          if (saldo.to_f + self.valor_gs.to_f).round(2) > adelanto.valor_guarani.to_f.round(2)
              errors[:base] << ( "Valor Ultrassa lo total de lo Documento" )
          end
      elsif adelanto.moeda == 2
          saldo = AdelantoCota.sum('valor_rs',:conditions => ["adelanto_id = ? and id != #{self.id}",self.adelanto_id])
          if (saldo.to_f + self.valor_rs.to_f).round(2) > adelanto.valor_real.to_f.round(2)
              errors[:base] << ( "Valor Ultrassa lo total de lo Documento" )
          end

      end
  end

end

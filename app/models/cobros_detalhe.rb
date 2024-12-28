class CobrosDetalhe < ActiveRecord::Base
    #audit(:create, :update, :destroy) { |model, user, action| "|#{model.cobro_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
    belongs_to :cobro

    validates_presence_of :cota,:documento_numero,:cobro_dolar,:cobro_guarani,:persona_id
    before_save :calcs
    def calcs
        if cobro.moeda == 0
            if self.cobro_dolar.to_f == self.saldo_dolar.to_f
              self.estado = 1
            else
              self.estado = 0
            end
           self.cobro_guarani     = self.cobro_dolar.to_f * cobro.cotacao.to_i
           self.desconto_guarani = self.desconto_dolar.to_f * cobro.cotacao.to_i
           self.interes_guarani  = self.interes_dolar.to_f * cobro.cotacao.to_i
          self.saldo_perc = ((self.cobro_dolar.to_f / self.valor_dolar.to_f) * 100).round(4)
        elsif cobro.moeda == 1
            if self.cobro_guarani.to_f == self.saldo_guarani.to_f
              self.estado = 1
            else
              self.estado = 0
            end

           self.cobro_dolar = self.cobro_guarani.to_f / cobro.cotacao.to_i
           self.desconto_dolar = self.desconto_guarani.to_f / cobro.cotacao.to_i
           self.interes_dolar  = self.interes_guarani.to_f / cobro.cotacao.to_i
           self.saldo_perc = ((self.cobro_guarani.to_f / self.valor_guarani.to_f) * 100).round(4)
        else
            if self.cobro_real.to_f == self.saldo_real.to_f
              self.estado = 1
            else
              self.estado = 0
            end

           self.cobro_guarani     = self.cobro_real.to_f * cobro.cotacao_real.to_i
           self.desconto_guarani = self.desconto_real.to_f * cobro.cotacao_real.to_i
           self.interes_guarani  = self.interes_real.to_f * cobro.cotacao_real.to_i

           self.cobro_dolar       = self.cobro_guarani.to_f / cobro.cotacao.to_i
           self.desconto_dolar   = self.desconto_guarani.to_f / cobro.cotacao.to_i
           self.interes_dolar    = self.interes_guarani.to_f / cobro.cotacao.to_i
        end
    end
end

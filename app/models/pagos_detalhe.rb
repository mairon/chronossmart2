class PagosDetalhe < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.pago_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :pago
  belongs_to :centro_custo
  belongs_to :rubro
  belongs_to :plano_de_conta

    validates_presence_of :cota,:documento_numero,:pago_dolar,:pago_guarani,:persona_id
    before_save :calcs
    def calcs
        if pago.moeda == 0
            if self.pago_dolar.to_f == self.saldo_dolar.to_f
              self.estado = 1
            else
              self.estado = 0
            end
           self.pago_guarani     = self.pago_dolar.to_f * pago.cotacao.to_i
           self.desconto_guarani = self.desconto_dolar.to_f * pago.cotacao.to_i
           self.interes_guarani  = self.interes_dolar.to_f * pago.cotacao.to_i

           self.pago_real     = self.pago_dolar.to_f * pago.cotacao_rs_us.to_f
           self.desconto_real = self.desconto_dolar.to_f * pago.cotacao_rs_us.to_f
           self.interes_real  = self.interes_dolar.to_f * pago.cotacao_rs_us.to_f

        elsif pago.moeda == 1
            if self.pago_guarani.to_f == self.saldo_guarani.to_f
              self.estado = 1
            else
              self.estado = 0
            end          
           self.pago_dolar       = self.pago_guarani.to_f / pago.cotacao.to_i
           self.desconto_dolar   = self.desconto_guarani.to_f / pago.cotacao.to_i
           self.interes_dolar    = self.interes_guarani.to_f / pago.cotacao.to_i

           self.pago_real     = self.pago_guarani.to_f / pago.cotacao_real.to_i
           self.desconto_real = self.desconto_guarani.to_f / pago.cotacao_real.to_i
           self.interes_real  = self.interes_guarani.to_f / pago.cotacao_real.to_i
        else
          
          if self.pago_real.to_f == self.saldo_real.to_f
            self.estado = 1
          else
            self.estado = 0
          end

           self.pago_guarani     = self.pago_real.to_f * pago.cotacao_real.to_i
           self.desconto_guarani = self.desconto_real.to_f * pago.cotacao_real.to_i
           self.interes_guarani  = self.interes_real.to_f * pago.cotacao_real.to_i

           self.pago_dolar       = self.pago_real.to_f / pago.cotacao_rs_us.to_f
           self.desconto_dolar   = self.desconto_real.to_f / pago.cotacao_rs_us.to_f
           self.interes_dolar    = self.interes_real.to_f / pago.cotacao_rs_us.to_f
        end
    end
end

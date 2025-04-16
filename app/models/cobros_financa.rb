class CobrosFinanca < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.cobro_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :cobro
  belongs_to :forma_pago

  before_save :calcs

  after_create :trigger_adelanto_cliente, if: :adelanto?
  after_destroy :trigger_adelanto_cliente_destroy, if: :adelanto?

  def adelanto?
    self.forma_pago_id.to_i == 12
  end

  def trigger_adelanto_cliente
    Cliente.create(
        tabela_id: self.id,
        tabela: 'COBROS_FINANCAS',
        documento_numero_01: self.documento_numero_01,
        documento_numero_02: self.documento_numero_02,
        documento_numero: self.documento_numero,
        cota: 1,
        divida_guarani: self.valor_guarani,
        divida_dolar: self.valor_dolar,
        divida_real: self.valor_real,
        cobro_guarani: 0,
        cobro_dolar: 0,
        cobro_real: 0,
        liquidacao: 0,
        moeda: cobro.moeda,
        sigla_proc: 'CBF',
        cod_proc: self.cobro_id,
        unidade_id: self.cobro.unidade_id,
        data: self.data,
        descricao: self.descricao,
        vencimento: self.data,
        persona_id: self.persona_id,

      )

      extrato = Cliente.where(persona_id: self.persona_id, documento_numero_01: self.documento_numero_01, documento_numero_02: self.documento_numero_02, documento_numero: self.documento_numero, cota: 1 )
      if cobro.moeda == 0
         if extrato.sum('divida_dolar - cobro_dolar') == 0 
            extrato.update_all(liquidacao: 1)
         end

      elsif cobro.moeda == 1
         if extrato.sum('divida_guarani - cobro_guarani').to_f == 0 
            extrato.update_all(liquidacao: 1)
         end

      elsif cobro.moeda == 2
         if extrato.sum('divida_real - cobro_real').to_f == 0 
            extrato.update_all(liquidacao: 1)
         end
      end
  end

  def trigger_adelanto_cliente_destroy
    Cliente.where(tabela_id: self.id, tabela: 'COBROS_FINANCAS' ).destroy_all
    extrato = Cliente.where(persona_id: self.persona_id, documento_numero_01: self.documento_numero_01, documento_numero_02: self.documento_numero_02, documento_numero: self.documento_numero, cota: 1 )
    extrato.update_all(liquidacao: 0)
  end 

  def calcs
    self.data = cobro.data;
    self.persona_id = cobro.persona_id;
    self.persona_nome = cobro.persona_nome;
    conta = Conta.find_by_id(self.conta_id);
    self.conta_nome = conta.nome.to_s unless self.conta_id.blank?
    self.moeda = conta.moeda.to_s unless self.conta_id.blank?
    conta_vuelto = Conta.find_by_id(self.vuelto_conta_id);
    self.vuelto_conta_nome   = conta_vuelto.nome.to_s unless self.vuelto_conta_id.blank?

    self.cheque_valor_dolar = self.valor_dolar
    self.cheque_valor_guarani = self.valor_guarani
    self.cheque_valor_real = self.valor_real
  end
end

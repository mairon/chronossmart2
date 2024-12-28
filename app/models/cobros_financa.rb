class CobrosFinanca < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.cobro_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :cobro
  belongs_to :forma_pago

  before_save :calcs
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

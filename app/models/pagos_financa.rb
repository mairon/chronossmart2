class PagosFinanca < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.pago_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :pago
  belongs_to :forma_pago
  before_save :calcs
  validates :forma_pago_id, 	:conta_id, :presence => true

  def calcs
    self.data = pago.data;
    self.persona_id = pago.persona_id;
    self.persona_nome = pago.persona_nome;

    conta = Conta.find_by_id(self.conta_id);
    self.conta_nome = conta.nome.to_s unless self.conta_id.blank?
    self.moeda = conta.moeda.to_s unless self.conta_id.blank?

    if pago.moeda == 0
       self.valor_guarani  = self.valor_dolar.to_f * pago.cotacao.to_i
       self.valor_real     = self.valor_dolar.to_f * pago.cotacao_rs_us.to_f

    elsif pago.moeda == 1
       self.valor_dolar    = self.valor_guarani.to_f / pago.cotacao.to_i
       self.valor_real     = self.valor_guarani.to_f / pago.cotacao_real.to_i
    else
       self.valor_guarani     = self.valor_real.to_f * pago.cotacao_real.to_i
       self.valor_dolar       = self.valor_real.to_f / pago.cotacao_rs_us.to_f
    end
  end
end

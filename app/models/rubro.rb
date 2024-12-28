class Rubro < ActiveRecord::Base

  validates_presence_of :descricao

  def before_save
    @plano = PlanoDeConta.find_by_id(self.plano_de_conta_id);
    self.plano_de_conta_descricao = @plano.descricao.to_s;
    self.codigo = @plano.codigo.to_s;
  end

end

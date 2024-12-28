class EntradaSaidaFuncDetalhe < ActiveRecord::Base
  belongs_to :entrada_saida_func

  def before_save
    pd = Persona.find_by_id(self.persona_id);
    self.persona_nome = pd.nome.to_s unless self.persona_id.blank?
    self.persona_doc = pd.ruc.to_s unless self.persona_id.blank?
  end  

end

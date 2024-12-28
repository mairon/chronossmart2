class Metum < ActiveRecord::Base

	before_save :finds

  def finds

	  #busca vendedor
	  vend = Persona.find_by_id(self.persona_id);
	  self.persona_nome = vend.nome.to_s unless self.persona_id.blank?
  end

end

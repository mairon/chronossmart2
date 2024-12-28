class MetaDetalhe < ActiveRecord::Base
  belongs_to :metas

  validates :comicao_max, :comicao_min, :persona_id, :setor_id, :presence => true

  before_save :finds

  def finds
  	#busca empleado
	  per = Persona.find_by_id(self.persona_id);
	  self.persona_nome = per.nome.to_s unless self.persona_id.blank?

	  #busca setor
	  set = Setor.find_by_id(self.setor_id);
	  self.setor_nome = set.nome.to_s unless self.setor_id.blank?
  end
  
end

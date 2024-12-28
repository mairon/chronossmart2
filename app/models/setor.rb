class Setor < ActiveRecord::Base

  validates_uniqueness_of :sigla,:nome
  validates_presence_of :nome,:sigla

  belongs_to :meta_detalhes
  
  before_save :finds
  def finds
  	ps = Persona.find_by_id(self.responsavel_id,:select => 'id,nome')
  	self.responsavel_nome  = ps.nome unless self.responsavel_id.blank?
  end
end

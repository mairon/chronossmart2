class ControleVisitum < ActiveRecord::Base  
  validates :nc, :numericality =>  { :greater_than => 0 }
  validates :nc, :presence => true

	before_save :finds

  def finds

  	#busca cliente
	  per = Persona.find_by_id(self.persona_id);
	  self.persona_nome = per.nome.to_s unless self.persona_id.blank?

	  #busca consultor
	  consul = Persona.find_by_id(self.consultor_id);
	  self.consultor_nome = consul.nome.to_s unless self.consultor_id.blank?

	  #busca consultor
	  serv = Servico.find_by_id(self.servico_id);
	  self.servico_nome = serv.nome.to_s unless self.servico_id.blank?
	  	
	  end

  end 
  
  

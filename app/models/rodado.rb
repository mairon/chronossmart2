class Rodado < ActiveRecord::Base
	before_save :finds

	def finds
		plano = PlanoDeConta.find_by_id(self.rubro_grupo_id, select: 'id,descricao,codigo');
	  self.grupo_rubro_codigo  = plano.codigo unless self.rubro_grupo_id.blank?
	end
end

class ConfigContabil < ActiveRecord::Base
	before_save :finds
	def finds
	    deb = Rubro.find_by_id(self.rubro_deb_id)
	    self.rubro_deb_nome   = deb.descricao.to_s unless self.rubro_deb_id.blank?
	    self.rubro_deb_codigo = deb.codigo.to_s unless self.rubro_deb_id.blank?

	    cre = Rubro.find_by_id(self.rubro_cre_id)
	    self.rubro_cre_nome   = cre.descricao.to_s unless self.rubro_cre_id.blank?
	    self.rubro_cre_codigo = cre.codigo.to_s unless self.rubro_cre_id.blank?

	end
end

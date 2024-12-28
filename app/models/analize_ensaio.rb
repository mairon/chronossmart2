class AnalizeEnsaio < ActiveRecord::Base
	belongs_to :analize_amostra
	belongs_to :analize
	belongs_to :conj_ensaio
	before_save :finds
	def finds
    if self.manual == 0
  		per = Persona.find_by_id(analize.empresa_id)
  		ce = ConjEnsaio.find_by_id(self.conj_ensaio_id);
      self.persona_id = per.id
      tabela_desconto = PersonaTabelaDesc.find_by_conj_ensaio_id(self.conj_ensaio_id, :conditions => ["persona_id = #{analize.empresa_id}"]);

      if tabela_desconto != nil
        tab_desc = tabela_desconto.desc_us.to_f
      else
        tab_desc = 0
      end

      if analize.cortesia.to_i == 1 #quando tiver
        self.valor_us = 0
        self.valor_gs = 0
        self.valor_rs = 0
      else
        if per.tipo_cliente == 1 and per.tipo_maiorista == 0 and  per.tipo_ap == 0 and per.tipo_ap_especial == 0
          self.valor_us = (ce.preco_us.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_gs = (ce.preco_gs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_rs = (ce.preco_rs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
        elsif per.tipo_maiorista == 1
          self.valor_us = (ce.preco_corp_us.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_gs = (ce.preco_corp_gs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_rs = (ce.preco_corp_rs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
        elsif per.tipo_ap == 1
          self.valor_us = (ce.preco_ap_us.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_gs = (ce.preco_ap_gs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_rs = (ce.preco_ap_rs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
        elsif per.tipo_ap_especial == 1
          self.valor_us = (ce.preco_ap_especial_us.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_gs = (ce.preco_ap_especial_gs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_rs = (ce.preco_ap_especial_rs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
        else
          self.valor_us = (ce.preco_us.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_gs = (ce.preco_gs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
          self.valor_rs = (ce.preco_rs.to_f - (per.desc_especial.to_f + tab_desc.to_f)) unless self.conj_ensaio_id.blank?
        end

      end
  	end
  end
end

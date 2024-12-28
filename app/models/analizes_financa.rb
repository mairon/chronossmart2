class AnalizesFinanca < ActiveRecord::Base
	belongs_to :analize
	validates_presence_of :conta_id, :if => :tipo?
	validates_presence_of :documento_numero, :if => :fatura?

	validates_presence_of :valor_us, :valor_gs, :valor_rs, :cota

	def tipo?
    self.tipo.to_i == 0
  end

	def fatura?
    self.fatura.to_i == 1
  end
  before_save :finds

  def finds
  	if self.fatura == 0
  		self.documento_numero = self.analize_id.to_s
  	end
    primeira_amostra = AnalizeAmostra.first(:conditions => ["analize_id = #{analize.id}"], :order => 'amostra')
    ultima_amostra = AnalizeAmostra.last(:conditions => ["analize_id = #{analize.id}"], :order => 'amostra')
    self.obs = "#{analize.tipo.sigla}#{analize.solicitude.to_s.rjust(6,'0')} / #{primeira_amostra.amostra}-#{ultima_amostra.amostra}"

    conta = Conta.find_by_id(self.conta_id);
    self.conta_nome   = conta.nome.to_s unless self.conta_id.blank?
	
  end
end

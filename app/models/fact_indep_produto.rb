class FactIndepProduto < ActiveRecord::Base
	belongs_to :fact_indep	
	belongs_to :vendas_produto
	belongs_to :produto
	validates_presence_of :produto_id, :quantidade, :unit_gs, :fact_indep_id

	before_save :calcs

	def calcs 
		self.tot_gs = self.quantidade.to_f * self.unit_gs.to_f
	end
end

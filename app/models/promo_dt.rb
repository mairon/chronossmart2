class PromoDt < ActiveRecord::Base
	belongs_to :promo
	belongs_to :produto
	before_save :calc_desc

	def calc_desc
		prod = ProdutosTabelaPreco.where("tabela_preco_id = #{promo.tabela_preco_id} and produto_id = #{self.produto_id}").last
		self.preco_original_gs = prod.preco_1_gs.to_f;
		self.preco_venda_gs =  (prod.preco_1_gs.to_f - (prod.preco_1_gs.to_f * (self.desc_porce.to_f / 100))) ;
	end
end

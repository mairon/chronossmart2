class PlanoVenda < ActiveRecord::Base
	belongs_to :persona
	belongs_to :produto
	belongs_to :tabela_preco
	has_many :solicitude_creditos
	has_many :plano_venda_conds, order: 1, :dependent => :destroy
	has_many :plano_venda_docs, order: 1, :dependent => :destroy

	before_save :find_preco
	after_create :gera_conds

	def find_preco
		preco = ProdutosTabelaPreco.where(tabela_preco_id: self.tabela_preco_id, produto_id: self.produto_id).last
		self.valor_gs = preco.preco_1_gs.to_f
		self.valor_us = preco.preco_1_us.to_f
	end

	def gera_conds
		#gera condições auto
		if Empresa.last.segmento.to_i == 2
			PlanoVendaCond.create(
				plano_venda_id: self.id,
				nome: 'INICIAL'
			)

			PlanoVendaCond.create(
				plano_venda_id: self.id,
				nome: 'REFUERZO'
			)


			PlanoVendaCond.create(
				plano_venda_id: self.id,
				nome: 'CUOTA'
			)

			PlanoVendaCond.create(
				plano_venda_id: self.id,
				nome: 'USADO'
			)
		end
	end
end

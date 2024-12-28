class ComprasEmpaque < ActiveRecord::Base
	belongs_to :compra
	belongs_to :produto
	belongs_to :produtos_grade
  before_save :calcs
  before_destroy :atuliza_preco

	def calcs
		#atuliza codigo de barra
		find_barra = ProdutosGrade.find_by_id(self.produtos_grade_id)
		find_barra.update_attribute :barra, self.barra
		#atuliza preco
		if self.preco_gs.to_f != self.preco_alterado_gs.to_f
			find_tabela = ProdutosTabelaPreco.find_by_produto_id(self.produtos_grade.produto_id, :conditions => ["unidade_id = #{compra.unidade_id}"])
			find_tabela.update_attribute :preco_1_gs, self.preco_alterado_gs.to_f
			find_tabela.update_attribute :preco_2_gs, ( self.preco_alterado_gs.to_f - ( self.preco_alterado_gs.to_f * 0.25)).to_i.round(-3)

			find_tabela.update_attribute :preco_1_us, (self.preco_alterado_gs.to_f / compra.cotacao.to_f)
			find_tabela.update_attribute :preco_2_us, (((self.preco_alterado_gs.to_f - ( self.preco_alterado_gs.to_f * 0.25)).to_i.round(-3)) / compra.cotacao.to_f)
		end
	end
	def atuliza_preco
		#regra de atulizacao de preco realce
		if compra.unidade_id == 5
			find_tabela = ProdutosTabelaPreco.find_by_produto_id(self.produtos_grade.produto_id, :conditions => ["unidade_id = #{compra.unidade_id}"])
			find_tabela.update_attribute :preco_1_gs, self.preco_gs.to_f
			find_tabela.update_attribute :preco_2_gs, (self.preco_gs.to_f - (self.preco_gs.to_f * 0.25)).to_i.round(-3)

			find_tabela.update_attribute :preco_1_us, (self.preco_gs.to_f / compra.cotacao.to_f )
			find_tabela.update_attribute :preco_2_us, (((self.preco_gs.to_f - (self.preco_gs.to_f * 0.25)).to_i.round(-3)) / compra.cotacao.to_f )
		end
	end
end

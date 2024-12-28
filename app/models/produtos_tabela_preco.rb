class ProdutosTabelaPreco < ActiveRecord::Base
	belongs_to :unidade
	belongs_to :produto
	belongs_to :tabela_preco

	validates_uniqueness_of :tabela_preco_id, scope: [:unidade_id, :produto_id], message: " ja cadastrado."
end

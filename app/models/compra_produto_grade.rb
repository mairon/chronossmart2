class CompraProdutoGrade < ActiveRecord::Base
	belongs_to :compras_produto
	belongs_to :cor
	belongs_to :tamanho
end

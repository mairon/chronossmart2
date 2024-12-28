class SubGrupoPreco < ActiveRecord::Base
	belongs_to :unidade
	belongs_to :tabela_preco
end

class ClaseTabelaPreco < ActiveRecord::Base
  belongs_to :unidade
  belongs_to :tabela_preco
  validates_uniqueness_of :tabela_preco_id, scope: [:clase_id, :unidade_id], message: " ja cadastrado."
end

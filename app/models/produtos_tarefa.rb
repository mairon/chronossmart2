class ProdutosTarefa < ActiveRecord::Base
  belongs_to :produto
  belongs_to :tarefa
end

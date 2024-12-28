class ProdutoComposicaosVendasProduto < ActiveRecord::Base
  belongs_to :produto_composicao
  belongs_to :vendas_produto

end

class TrocaProduto < ActiveRecord::Base
  belongs_to :troca
  belongs_to :produto
end

class DepositoProduto < ActiveRecord::Base
  belongs_to :deposito
  belongs_to :produto
end

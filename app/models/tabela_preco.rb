class TabelaPreco < ActiveRecord::Base
  validates :nome, presence: true
  validates_uniqueness_of :nome

  belongs_to :produtos_tabela_precos
end

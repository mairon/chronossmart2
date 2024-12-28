class Grupo < ActiveRecord::Base
  has_many :produtos, dependent: :restrict
  #validacoes
  validates_presence_of :descricao
  validates_uniqueness_of :descricao

end

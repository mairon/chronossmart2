class Elemento < ActiveRecord::Base

  validates :sigla, :nome, :formula, :fator, :presence => true

end

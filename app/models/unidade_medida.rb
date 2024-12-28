class UnidadeMedida < ActiveRecord::Base
  validates :nome, :sigla, presence: true
end

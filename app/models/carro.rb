class Carro < ActiveRecord::Base
  belongs_to :marca
  attr_accessible :chassi, :cor, :fabricacao, :motor, :nome, :observacoes, :valor
end

class Servico < ActiveRecord::Base
  belongs_to :servico
  attr_accessible :created_at, :data_final, :data_inicio, :descricao, :nome, :obs, :tipo, :updated_at, :valor
end

class PersonaAcao < ActiveRecord::Base
  attr_accessible :acao_id, :data, :horas, :obs, :persona_id, :responsavel_id, :retorno, :retorno_data, :retorno_horas, :status
end

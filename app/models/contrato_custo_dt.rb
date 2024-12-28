class ContratoCustoDt < ActiveRecord::Base
  attr_accessible :contrato_custo_id, :contrato_id, :data, :persona_id, :valor_gs, :valor_rs, :valor_us
end

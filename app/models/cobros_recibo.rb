class CobrosRecibo < ActiveRecord::Base
  attr_accessible :cobro_id, :data, :documento_numero, :documento_numero_01, :documento_numero_02, :moeda, :persona_id, :persona_nome, :tipo, :valor_gs, :valor_us
end

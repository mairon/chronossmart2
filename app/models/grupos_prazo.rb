class GruposPrazo < ActiveRecord::Base
	belongs_to :persona_prazo
	belongs_to :prazo
end

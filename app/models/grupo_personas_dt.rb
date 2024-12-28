class GrupoPersonasDt < ActiveRecord::Base
	belongs_to :grupo_persona
	belongs_to :persona
	validates :persona_id, presence: true
  validates_uniqueness_of :persona_id, scope: [:grupo_persona_id], message: " ja cadastrado."

end

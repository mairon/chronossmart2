class GrupoPersona < ActiveRecord::Base
	has_many :grupo_personas_dts, order: 'id desc', dependent: :destroy
  validates :nome, presence: true
end

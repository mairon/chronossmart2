class AberturaCaixa < ActiveRecord::Base
	#audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to :usuario
	belongs_to :terminal
	belongs_to :turno
	validates_presence_of :usuario_id, :terminal_id, :turno_id
	#validates_uniqueness_of :usuario_id, scope: [:turno_id, :data, :usuario_id, :unidade_id], message: "já Habilitado."
end

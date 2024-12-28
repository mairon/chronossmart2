class BocaCx < ActiveRecord::Base
	has_many :boca_cx_produtos
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
end

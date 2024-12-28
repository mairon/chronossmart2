class CondLiqVendido < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.cond_liq_id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to :cond_liq
	belongs_to :produtos_grade
end

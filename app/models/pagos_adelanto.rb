class PagosAdelanto < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.pago_id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
 belongs_to :pago
end

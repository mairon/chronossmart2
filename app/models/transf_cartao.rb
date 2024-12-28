class TransfCartao < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
	has_many :transf_cartao_dts, :order => 'id desc', :dependent => :destroy
	validates_presence_of :conta_origem_id, :conta_destino_id
end

class Conferencia < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to :sub_grupo
	belongs_to :grupo
	belongs_to :deposito
  has_many :conferencia_produtos,   :order => 'id desc', :dependent => :destroy

end

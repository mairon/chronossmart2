class Terminal < ActiveRecord::Base
	#audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	validates_presence_of :nome
	validates_uniqueness_of :nome
	has_many :terminal_contas,   :order => 'id', :dependent => :destroy
end

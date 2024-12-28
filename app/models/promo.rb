class Promo < ActiveRecord::Base
	has_many :promo_dts, :order => 'id desc', :dependent => :destroy
	
	validates_presence_of :nome,:tabela_preco_id
	belongs_to :tabela_preco
	belongs_to :clase
	belongs_to :colecao
	belongs_to :grupo
	belongs_to :sub_grupo
end

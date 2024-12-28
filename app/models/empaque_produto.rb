class EmpaqueProduto < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.empaque_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
	belongs_to :empaque
	belongs_to :produto
	validates_presence_of :produtos_grade_id
	before_save :calcs

	def calcs
		cd = VendasProduto.find_by_produtos_grade_id(self.produtos_grade_id, :conditions => ["venda_id = #{empaque.venda_id}"])
    self.produto_id        = cd.produto_id
    self.produto_nome      = cd.produto_nome
    self.cor_id            = cd.cor_id
    self.cor_nome          = cd.cor_nome
    self.tamanho_id        = cd.tamanho_id
    self.tamanho_nome      = cd.tamanho_nome
	end

end

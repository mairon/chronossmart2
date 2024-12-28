class CondLiqProduto < ActiveRecord::Base
    audit(:create, :update, :destroy) { |model, user, action| "|#{model.cond_liq_id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to :cond_liq
	belongs_to :produtos_grade
	before_save :calcs

	def calcs
    	cd = CondicionalProduto.find_by_id(self.condicional_produto_id)
        self.data              = cond_liq.data
        self.produto_id        = cd.produto_id
        self.condicional_id    = cd.condicional_id
        self.produto_nome      = cd.produto_nome
        self.fabricante_cod    = cd.fabricante_cod
        self.unitario_us       = cd.unitario_us
        self.unitario_gs       = cd.unitario_gs
        self.total_us          = cd.total_us
        self.total_gs          = cd.total_gs
        self.deposito_id       = cd.deposito_id
        self.moeda             = cd.moeda
        self.persona_id        = cd.persona_id
	end
end

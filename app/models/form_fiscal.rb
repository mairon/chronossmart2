class FormFiscal < ActiveRecord::Base
	belongs_to :persona
	belongs_to :produto
	belongs_to :unidade

	before_update :calcs
	def calcs
		if self.sigla_proc == 'VTI'		
			per = Persona.find_by_id(self.persona_id)
			self.ruc = per.ruc
			self.persona_nome = per.nome_fatura
			prod = Produto.find_by_id(self.produto_id)
		end
	end


def self.send_transmite_de


end

end

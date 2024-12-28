class UsuarioPerfil < ActiveRecord::Base
	belongs_to :menu, select: 'id,codigo,nome,url,sub, nome_pt_br, nome_es'
	before_save :busca_codigo

	def busca_codigo
			self.codigo = menu.codigo
	end
end

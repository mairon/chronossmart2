class ListaCargaProduto < ActiveRecord::Base
	belongs_to :produto
	belongs_to :presupuesto
	validates :quantidade, numericality:  { :greater_than => 0 }  
	after_save :saldo_pedido
	after_destroy :saldo_pedido


	def saldo_pedido 
		saldo_pedido = PresupuestoProduto.where(presupuesto_id: self.presupuesto_id).sum(:quantidade)
		saldo_lista  = ListaCargaProduto.where(presupuesto_id: self.presupuesto_id).sum(:quantidade)
		pedido = Presupuesto.find_by_id(self.presupuesto_id)
		if saldo_pedido.to_f == saldo_lista.to_f
			pedido.update_attribute :status, 3
		elsif saldo_lista.to_f == 0
			pedido.update_attribute :status, 0
		else
			pedido.update_attribute :status, 2
		end
	end
end

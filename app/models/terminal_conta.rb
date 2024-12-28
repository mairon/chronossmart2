class TerminalConta < ActiveRecord::Base
	belongs_to :terminal
	belongs_to :forma_pago
	belongs_to :conta

	before_save :finds

  def finds
    c = Conta.find_by_id(self.conta_id);
    self.moeda = c.moeda
	end

end

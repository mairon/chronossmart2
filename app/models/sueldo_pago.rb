class SueldoPago < ActiveRecord::Base
	belongs_to :sueldo
	belongs_to :conta
	before_save :finds

  def finds
    conta = Conta.find_by_id(self.conta_id);
    self.moeda = conta.moeda.to_s unless self.conta_id.blank?
  end

end

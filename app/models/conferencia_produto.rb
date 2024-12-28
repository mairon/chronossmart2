class ConferenciaProduto < ActiveRecord::Base
	belongs_to :conferencia
	validates_presence_of :produto_id
	#validates :custo_medio_gs, numericality:  { :greater_than => 0 }
end

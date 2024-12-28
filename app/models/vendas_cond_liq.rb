class VendasCondLiq < ActiveRecord::Base
	belongs_to :venda
	belongs_to :cond_liq
end

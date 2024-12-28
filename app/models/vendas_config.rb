class VendasConfig < ActiveRecord::Base
	belongs_to :persona
	belongs_to :unidade
end

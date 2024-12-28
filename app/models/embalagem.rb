class Embalagem < ActiveRecord::Base
	belongs_to :persona
	belongs_to :produto
end

class ProdutoCor < ActiveRecord::Base
	has_and_belongs_to_many :produtos
end

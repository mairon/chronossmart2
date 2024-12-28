class TransfCartaoDt < ActiveRecord::Base
	belongs_to :transf_cartao
	belongs_to :cartao_bandeira
end

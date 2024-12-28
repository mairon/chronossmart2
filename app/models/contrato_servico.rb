class ContratoServico < ActiveRecord::Base
  belongs_to :contrato
  belongs_to :produto
end

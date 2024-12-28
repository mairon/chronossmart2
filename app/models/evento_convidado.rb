class EventoConvidado < ActiveRecord::Base
  belongs_to :evento
  belongs_to :vendas_produto
end

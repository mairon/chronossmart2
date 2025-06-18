class ComandaProduto < ActiveRecord::Base
  attr_accessible :comanda_id, :obs, :persona_id, :produto_id, :produto_nome, :quantidade, :tot_gs, :tot_us, :unit_gs, :unit_us
end

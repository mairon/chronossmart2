class VendasAnalize < ActiveRecord::Base
  attr_accessible :analize_id, :data, :persona_id, :porce, :solicitude, :status, :valor_gs, :valor_rs, :valor_us, :venda_id
end

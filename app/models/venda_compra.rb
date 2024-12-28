class VendaCompra < ActiveRecord::Base
  belongs_to :venda
  belongs_to :compra
end

class ContasFormaPago < ActiveRecord::Base
  belongs_to :conta
  belongs_to :forma_pago
end

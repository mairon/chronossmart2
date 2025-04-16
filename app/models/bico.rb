class Bico < ActiveRecord::Base
  belongs_to :deposito
  belongs_to :unidade
  validates_presence_of :nome, :deposito_id
end

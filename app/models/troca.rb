class Troca < ActiveRecord::Base
  belongs_to :persona
  belongs_to :usuario
  has_many :troca_produtos
end

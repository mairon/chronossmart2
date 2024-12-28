class NotaRemicao < ActiveRecord::Base
  has_many :nota_remicao_produtos, dependent: :destroy
  belongs_to :cidade
  belongs_to :persona
  has_one :romaneio
end

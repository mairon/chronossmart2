class Deposito < ActiveRecord::Base
  has_many :deposito_produtos, dependent: :destroy
  belongs_to :unidade
  validates_presence_of :nome, :unidade_id
  validates_uniqueness_of :nome, scope: [:unidade_id], message: " ja cadastrado."
end

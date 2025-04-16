class Chafe < ActiveRecord::Base
  validates :nome,:unidade_id,:persona_id, presence: true

  validates_uniqueness_of :nome, message: " ja cadastrado."

	belongs_to :persona
end

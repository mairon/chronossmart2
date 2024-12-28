class Prazo < ActiveRecord::Base

  validates_presence_of :nome, :dias
  validates_uniqueness_of :nome

end

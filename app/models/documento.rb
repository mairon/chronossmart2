class Documento < ActiveRecord::Base
  validates_presence_of :nome, :sigla
  validates_uniqueness_of :nome, :sigla
end

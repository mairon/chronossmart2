class Nota < ActiveRecord::Base
  belongs_to :negocio
  belongs_to :usuario
  has_many :negocio_historicos, :dependent => :destroy
end

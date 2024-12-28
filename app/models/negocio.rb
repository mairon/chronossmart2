class Negocio < ActiveRecord::Base
  belongs_to :etapa
  belongs_to :persona
  belongs_to :usuario
  has_many :negocio_produtos, :dependent => :destroy
  has_many :negocio_historicos, :dependent => :destroy
  has_many :tarefas, :dependent => :destroy
  
end

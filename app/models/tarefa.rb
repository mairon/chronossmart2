class Tarefa < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :persona
  belongs_to :negocio
  belongs_to :tipo_tarefa
  has_and_belongs_to_many :produtos
  has_many :produtos_tarefas, :dependent => :destroy
end

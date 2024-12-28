class Usuario < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  validates_presence_of   :usuario_nome,:usuario_senha
  validates_uniqueness_of :usuario_nome
  has_and_belongs_to_many :unidades
  has_and_belongs_to_many :contas
  has_many :usuario_perfils, :dependent => :destroy
  has_many :tarefas
  belongs_to :persona
  belongs_to :centro_custo
end

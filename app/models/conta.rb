class Conta < ActiveRecord::Base
	audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  belongs_to :unidade
  belongs_to :terminal
  has_and_belongs_to_many :forma_pagos
  has_and_belongs_to_many :usuarios

  validates_presence_of :nome, :unidade_id
  validates_uniqueness_of :nome, :scope=>[:unidade_id]
end

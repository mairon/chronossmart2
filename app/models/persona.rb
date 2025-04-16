class Persona < ActiveRecord::Base
  #acts_as_taggable
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :path => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename",
      :url => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename", default_url: 'default.jpg'
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :nome
  validates_uniqueness_of :ruc, :allow_blank => true

  # has_many :taggings
  # has_many :tags, through: :taggings
  has_many :persona_tabela_descs, :order => 1, :dependent => :destroy
  has_many :persona_chofers, :order => 1, :dependent => :destroy
  has_many :persona_produtos, :order => 1, :dependent => :destroy
  has_many :persona_contatos, :order => 'id desc', :dependent => :destroy
  has_many :persona_locais_entregas,   :order => 'id desc', :dependent => :destroy
  has_many :persona_rodados, :order => 'id desc', :dependent => :destroy
  has_many :persona_docs, :dependent => :destroy
  has_many :persona_ativos, :order => 1, :dependent => :destroy
  has_many :persona_bancos, :order => 1, :dependent => :destroy
  has_many :persona_ferias, :dependent => :destroy
  has_many :vendas, dependent: :restrict
  has_many :presupuestos, dependent: :restrict
  has_many :pedido_compras, dependent: :restrict
  has_many :empaques, dependent: :restrict
  has_many :sub_grupos, dependent: :restrict
  has_many :compras, dependent: :restrict
  has_many :contratos, dependent: :restrict
  has_and_belongs_to_many :forma_pagos
  belongs_to :tabela_preco
  belongs_to :cidade
  belongs_to :cargo
  belongs_to :paise
  belongs_to :seguimento
  belongs_to :unidade
  belongs_to :comite
  belongs_to :brigada
  belongs_to :turma
  before_create :finds


  def finds
    self.data_entrada = Time.now
    self.tabela_preco_id = TabelaPreco.first.id
  end
end

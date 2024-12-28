class Condicional < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to :persona
  has_many :condicional_produtos, :dependent => :destroy, :order => 'id desc'

  validates_presence_of :cotacao,
                        :persona_id,
                        :tabela_preco

  validates :cotacao, :numericality => { :greater_than => 0.01 }
  #validates :vendedor_id, numericality: { only_integer: true }
  validates :unidade_id, numericality: { only_integer: true }

  before_validation :finds

  def finds
  	self.tabela_preco = persona.cliente
    self.persona_nome = persona.nome
    if self.unidade_id.to_i ==  1
      self.tabela_preco = 1
    end
  end

  def self.filtro_busca(params)
    unidade = "unidade_id = #{params[:unidade]}"
    unless params[:inicio].blank?
    cond =  "#{unidade} AND data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' " 
    else
      cond =  "#{unidade}"
    end

    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  "#{unidade} AND #{tipo} = '#{params[:busca]}' " unless params[:busca].blank?
    elsif params[:tipo] == "NOMBRE"
      tipo = "persona_nome"
      cond =  "#{unidade} AND #{tipo} LIKE '#{params[:busca]}'" unless params[:busca].blank?
    end

    self.all(:conditions => "#{cond}",:order => "data desc, id desc")
  end
end

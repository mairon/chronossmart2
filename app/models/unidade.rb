class Unidade < ActiveRecord::Base
	has_many :sub_grupo_precos
	has_and_belongs_to_many :usuarios
	belongs_to :cidade
    belongs_to :persona


  has_attached_file :avatar, :path => "#{Empresa.last.nome}/:class/:attachment/:style/:filename",
      :url => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename", :styles => {
         :thumb => {:geometry => "50x50",
              :convert_options => "-gravity center -extent 50x50"}}, default_url: 'default.jpg'

  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']


  validates_presence_of :unidade_nome, :moeda
  validates_uniqueness_of :unidade_nome


  # Cache para unidade específica
  def self.cached_find(id)
    Rails.cache.fetch("unidade_#{id}", expires_in: 30.minutes) do
      find(id)
    end
  end
end

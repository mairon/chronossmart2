class Evento < ActiveRecord::Base
  has_attached_file :img_top, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :path => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename",
      :url => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename", default_url: 'default.jpg'
  validates_attachment_content_type :img_top, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']

  has_attached_file :img_bottom, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :path => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename",
      :url => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename", default_url: 'default.jpg'
  validates_attachment_content_type :img_bottom, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']

  has_many :evento_convidados, :dependent => :destroy
end

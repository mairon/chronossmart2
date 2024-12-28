class ProdutoImagen < ActiveRecord::Base

 #has_attached_file :foto, :styles => { :medium => "300x200>", :thumb => "100x50>" }, :path => "#{Empresa.last.nome}/system/:class/:attachment/:filename",
 #     :url => "#{Empresa.last.nome}/system/:class/:attachment/:filename", default_url: 'default.jpg'
  
 # validates_attachment_content_type :foto, :content_type => /\Aimage\/.*\Z/


  has_attached_file :foto, :styles => { :medium => "300x200>", :thumb => "100x50>" }, :path => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename",
      :url => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename", default_url: 'default.jpg'
  validates_attachment_content_type :foto, :content_type => /\Aimage\/.*\Z/

end

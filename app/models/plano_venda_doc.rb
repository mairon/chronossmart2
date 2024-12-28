class PlanoVendaDoc < ActiveRecord::Base
  has_attached_file :anexo, :path => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename",
      :url => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename", default_url: 'default.jpg'
  validates_attachment_content_type :anexo, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']

  belongs_to :documento
end

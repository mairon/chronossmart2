class PersonaDoc < ActiveRecord::Base
  has_attached_file :doc_attach, :path => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename",
      :url => "#{Empresa.last.nome}/system/:class/:attachment/:id_partition/:style/:filename", default_url: 'default.jpg'
  validates_attachment_content_type :doc_attach, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']
  belongs_to :documento
  belongs_to :persona

  validates :persona_id, presence: true

end

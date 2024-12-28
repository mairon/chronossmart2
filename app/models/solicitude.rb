class Solicitude < ActiveRecord::Base
  has_attached_file :anexo, default_url: 'default.jpg'
  validates_attachment_content_type :anexo, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']
  belongs_to :usuario
  belongs_to :motivo
end

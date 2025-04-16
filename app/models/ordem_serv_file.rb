class OrdemServFile < ActiveRecord::Base
  belongs_to :ordem_serv

  has_attached_file :picture
  validates_attachment_content_type :picture, presence: true, content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf",
   "application/xls", "application/doc", "application/xlsx", "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
   "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"], default_url: 'default.jpg'

end

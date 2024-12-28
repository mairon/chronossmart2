class Meta < ActiveRecord::Base

  has_many :meta_detalhes, :dependent => :destroy

  validates :moeda, :periodo_final, :periodo_inicio, :status, :presence => true
  
end

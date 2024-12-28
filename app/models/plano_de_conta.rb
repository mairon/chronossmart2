class PlanoDeConta < ActiveRecord::Base

  validates_presence_of :codigo,
                        :descricao
                        
  validates_uniqueness_of :codigo

  def self.find_recent
    all(:select => 'id,codigo,descricao',:order => 'codigo')
  end
end

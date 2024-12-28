class Pipeline < ActiveRecord::Base
  has_many :etapas, :dependent => :destroy
  has_many :pipeline_usuarios, :dependent => :destroy
end

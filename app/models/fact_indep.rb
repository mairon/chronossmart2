class FactIndep < ActiveRecord::Base
	has_many :fact_indep_produtos,   :order => 1, :dependent => :destroy
	validates_presence_of :persona_id
	belongs_to :persona
end

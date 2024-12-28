class AnalizeAmostra < ActiveRecord::Base
	belongs_to :analize
	has_many :analize_ensaios, :dependent => :destroy
	belongs_to :tipo
	validates_presence_of :amostra
	validates_uniqueness_of :amostra, :scope => [:tipo_id], :message => " ja cadastrado."
end

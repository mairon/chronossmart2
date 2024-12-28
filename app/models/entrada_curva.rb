class EntradaCurva < ActiveRecord::Base
  validates_presence_of :amostra_inicio,
                        :amostra_final
  validates_uniqueness_of :amostra_inicio

	validates :y, :x, :numericality =>  { :greater_than => 0 }
end

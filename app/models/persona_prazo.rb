class PersonaPrazo < ActiveRecord::Base
	belongs_to :persona
	belongs_to :grupo
	has_and_belongs_to_many :prazos,  join_table:  :grupos_prazos
end

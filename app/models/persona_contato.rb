class PersonaContato < ActiveRecord::Base
	belongs_to :persona
	belongs_to :cargo
end

class PersonaFeria < ActiveRecord::Base
  has_many :persona_escalas, :dependent => :destroy
  belongs_to :persona


end

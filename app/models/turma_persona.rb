class TurmaPersona < ActiveRecord::Base
  belongs_to :turma
  belongs_to :persona
end

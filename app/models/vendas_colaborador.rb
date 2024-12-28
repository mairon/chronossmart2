class VendasColaborador < ActiveRecord::Base
    belongs_to :venda
    def before_save
        person = Persona.find_by_id(self.persona_id,:select => 'id,nome')
        self.persona_nome = person.nome.to_s unless self.persona_id.blank?

    end

end

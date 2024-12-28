class RecepcaoNotaRemicao < ActiveRecord::Base
    has_many :recepcao_nota_remicao_produtos,   :order => 1

    validates_presence_of :origem_unidade_id,
    :deposito_id

    def before_save

        @unidade_origem           = Unidade.find_by_id( self.origem_unidade_id );
        self.origem_unidade_nome  = @unidade_origem.unidade_nome.to_s unless self.origem_unidade_id.blank? ;

        @deposito_origem          = Deposito.find_by_id( self.deposito_id );
        self.deposito_nome        = @deposito_origem.nome.to_s;

        @chofer                   = Persona.find_by_id( self.chofer_id );
        self.chofer_nome          = @chofer.nome.to_s unless self.chofer_id.blank? ;

        @transportadora           = Persona.find_by_id( self.transportadora_id );
        self.transportadora_nome  = @transportadora.nome.to_s unless self.transportadora_id.blank?;

        @unidade_destino          = Unidade.find_by_id( self.destino_unidade_id );
        self.destino_unidade_nome = @unidade_destino.unidade_nome.to_s unless self.destino_unidade_id.blank? ;

        @cliente                  = Persona.find_by_id( self.destino_persona_id );
        self.destino_persona_nome = @cliente.nome.to_s  unless self.destino_persona_id.blank? ;

        @cidade                   = Cidade.find_by_id( self.cidade_id );
        self.cidade_nome          = @cidade.nome.to_s unless self.cidade_id.blank? ;
    end


end

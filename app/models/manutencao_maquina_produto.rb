class ManutencaoMaquinaProduto < ActiveRecord::Base

    belongs_to :manutencao_maquina
    validates_presence_of :quantidade,:produto_id


    def validate                         #
        saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ?",self.produto_id])
        if ( saldo.to_f <= 0   )
            errors.add_to_base( "No tiene saldo Disponible" )
        end

        if ( self.quantidade > saldo.to_f   )
            errors.add_to_base( "La quantidade es Mayor que su Saldo" )
        end
    end

    def before_save                      #
        resp = Persona.find_by_id(self.responsavel_id)
        self.responsavel_nome = resp.nome unless self.responsavel_id.blank?

        deposito = Deposito.find_by_id(self.deposito_id)
        self.deposito_nome = deposito.nome unless self.deposito_id.blank?

        self.custo_guarani = self.custo_dolar.to_f * self.cotacao.to_f
        self.unitario_guarani = self.unitario_dolar.to_f * self.cotacao.to_f

    end

end

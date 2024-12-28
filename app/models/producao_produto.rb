class ProducaoProduto < ActiveRecord::Base
    belongs_to :producao
    validates_presence_of :quantidade, :produto_id

    before_save :calcs

    def validate                         #
        saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ?",self.produto_id])
        if ( saldo.to_f <= 0   )
            errors.add_to_base( "No tiene saldo Disponible" )
        end

        if ( self.quantidade > saldo.to_f   )
            errors.add_to_base( "La quantidade es Mayor que su Saldo" )
        end
    end
    
    def calcs
        resp = Persona.find_by_id(self.responsavel_id)
        self.responsavel_nome = resp.nome unless self.responsavel_id.blank?

        pd = Produto.find_by_id(self.produto_id)
        self.produto_nome = pd.nome unless self.produto_id.blank?
        promedio_anterior = Stock.where("status = 0 and deposito_id = ? and produto_id = ? AND data <= ?",self.deposito_id,self.produto_id, self.data).last
        if promedio_anterior != nil
            self.custo_dolar = promedio_anterior.unitario_dolar
            self.custo_guarani = promedio_anterior.unitario_guarani
        end

        deposito = Deposito.find_by_id(self.deposito_id)
        self.deposito_nome = deposito.nome unless self.deposito_id.blank?
    end

end

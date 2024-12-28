class ManutencaoMaquina < ActiveRecord::Base
    has_many :manutencao_maquina_produtos

    validates_presence_of :cotacao,:quantidade,:produto_id,:vendedor_id

    def self.filtro(params)                                         #

        cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?

        if params[:tipo] == "CODIGO"
            tipo = "id"
            cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
        elsif params[:tipo] == "PRODUCTO"
            tipo = "produto_nome"
            cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
        end



        self.all(:conditions => cond,:order => 'data,id')
    end

    def before_save

        produto = Produto.find_by_id(self.produto_id)
        self.produto_nome = produto.nome
        self.clase_id     = produto.clase_id
        self.grupo_id     = produto.grupo_id
        self.sub_grupo_id = produto.sub_grupo_id

        deposito = Deposito.find_by_id(self.deposito_id)
        self.deposito_nome = deposito.nome unless self.deposito_id.blank?

        vendedor = Persona.find_by_id(self.vendedor_id)
        self.vendedor_nome = vendedor.nome unless self.vendedor_id.blank?

        if self.status == 1
            porcen_balcao      = self.porcen_balcao.to_f / 100.to_f
            adcional_balcao_us = self.custo_dolar.to_f * porcen_balcao.to_f
            adcional_balcao_gs = self.custo_guarani.to_f * porcen_balcao.to_f

            porcen_maio        = ( self.porcen_mayorista.to_f / 100.to_f )
            adcional_maio_us   = self.custo_dolar.to_f *  porcen_maio.to_f
            adcional_maio_gs   = self.custo_guarani.to_f *  porcen_maio.to_f

            porcen_mino        = ( self.porcen_corporativo.to_f / 100.to_f )
            adcional_mino_us   = self.custo_dolar.to_f *  porcen_mino.to_f
            adcional_mino_gs   = self.custo_guarani.to_f *  porcen_mino.to_f


            produto =   Produto.find_by_id(self.produto_id);

            produto.update_attribute :cotacao, self.cotacao.to_f
            produto.update_attribute :preco_venda_dolar, ( self.custo_dolar.to_f + adcional_balcao_us.to_f)
            produto.update_attribute :preco_venda_guarani, ( self.custo_guarani.to_f + adcional_balcao_gs.to_f)

            produto.update_attribute :preco_maiorista_dolar, ( self.custo_dolar.to_f + adcional_maio_us.to_f )
            produto.update_attribute :preco_maiorista_guarani,( self.custo_guarani.to_f + adcional_maio_gs.to_f )

            produto.update_attribute :preco_minorista_dolar,( self.custo_dolar.to_f + adcional_mino_us.to_f )
            produto.update_attribute :preco_minorista_guarani,( self.custo_guarani.to_f + adcional_mino_gs.to_f)
        end


    end

end

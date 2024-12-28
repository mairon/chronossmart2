class VendasEntradaProduto < ActiveRecord::Base
    belongs_to :venda

    
    validates_length_of   :documento_numero_01,
    :documento_numero_02, :maximum=>3,:message => "Tiene mas Numero do que lo permitido"


    validates_presence_of :cotacao,
    :persona_id,
    :documento_numero_01,
    :documento_numero_02,
    :documento_numero,
    :quantidade,
    :documento_timbrado

    def before_save

        @produto = Produto.find_by_id(self.produto_id,:select => 'id,nome,clase_id,grupo_id')
        self.produto_nome = @produto.nome.to_s
        self.clase_id     = @produto.clase_id.to_i
        self.grupo_id     = @produto.grupo_id.to_i

        person = Persona.find_by_id(self.persona_id,:select => 'id,nome')
        self.persona_nome = person.nome.to_s unless self.persona_id.blank?

        @documento = Documento.find_by_id(self.documento_id,:select => 'id,nome');
        self.documento_nome = @documento.nome.to_s;

        @deposito = Deposito.find_by_id(self.deposito_id,:select => 'id,nome');
        self.deposito_nome = @deposito.nome.to_s;

        cotacao = self.cotacao.to_f
        
        if self.moeda == 0
            self.exentas_guarani             =  self.exentas_dolar  * cotacao
            self.gravadas_05_guarani         =  self.gravadas_05_dolar * cotacao
            self.gravadas_10_guarani         =  self.gravadas_10_dolar * cotacao
            self.imposto_05_guarani          =  self.imposto_05_dolar * cotacao
            self.imposto_10_guarani          =  self.imposto_10_dolar * cotacao
            self.total_guarani               =  self.total_dolar * cotacao
            self.diferenca_comercial_guarani =  self.diferenca_comercial_dolar * cotacao
            self.total_comercial_guarani     =  self.total_comercial_dolar * cotacao
        else
            self.exentas_dolar               =  self.exentas_guarani  / cotacao
            self.gravadas_05_dolar           =  self.gravadas_05_guarani / cotacao
            self.gravadas_10_dolar           =  self.gravadas_10_guarani / cotacao
            self.imposto_05_dolar            =  self.imposto_05_guarani / cotacao
            self.imposto_10_dolar            =  self.imposto_10_guarani / cotacao
            self.total_dolar                 =  self.total_guarani / cotacao
            self.diferenca_comercial_dolar   =  self.diferenca_comercial_guarani / cotacao
            self.total_comercial_dolar       =  self.total_comercial_guarani / cotacao

        end

    def after_save      #
        produto =   Produto.find_by_id(self.produto_id);
        porcens = Grupo.find_by_id(produto.grupo_id)

        promedio_us      = ( self.total_comercial_dolar.to_f )
        promedio_gs      = ( self.total_comercial_guarani.to_f )

        porcen_balcao   = porcens.porcen_balcao.to_f / 100.to_f
        adcional_balcao_us = promedio_us.to_f * porcen_balcao.to_f
        adcional_balcao_gs = promedio_gs.to_f * porcen_balcao.to_f

        porcen_maio        = ( porcens.porcen_mayo.to_f / 100.to_f )
        adcional_maio_us   = promedio_us.to_f *  porcen_maio.to_f
        adcional_maio_gs   = promedio_gs.to_f *  porcen_maio.to_f

        porcen_mino     = ( porcens.porcen_mino.to_f / 100.to_f )
        adcional_mino_us   = promedio_us.to_f *  porcen_mino.to_f
        adcional_mino_gs   = promedio_gs.to_f *  porcen_mino.to_f

        
        produto.update_attribute :cotacao, self.cotacao.to_f
        produto.update_attribute :data, ( self.data )

        produto.update_attribute :preco_venda_dolar, ( promedio_us.to_f + adcional_balcao_us.to_f)
        produto.update_attribute :preco_venda_guarani, ( promedio_gs.to_f + adcional_balcao_gs.to_f)

        produto.update_attribute :preco_maiorista_dolar, ( promedio_us.to_f + adcional_maio_us.to_f )
        produto.update_attribute :preco_maiorista_guarani,( promedio_gs.to_f + adcional_maio_gs.to_f )

        produto.update_attribute :preco_minorista_dolar,( promedio_us.to_f + adcional_mino_us.to_f )
        produto.update_attribute :preco_minorista_guarani,( promedio_gs.to_f + adcional_mino_gs.to_f)
    end


    end


end

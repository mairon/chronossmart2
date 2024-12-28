class PresupuestoProduto < ActiveRecord::Base
    #audit(:create, :update, :destroy) { |model, user, action| "|#{model.presupuesto_id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
    belongs_to :presupuesto
    belongs_to :produto
    belongs_to :persona
    has_one :vendas_produto, dependent: :restrict

    validates_presence_of :produto_id, :quantidade
    validate :valide_total

    before_create :add_produtos_compostos
    before_save :finds

    def add_produtos_compostos
      if Empresa.last.segmento.to_i == 1
        if self.tipo == 1 #registro origem
          if self.produto.grupo_id == 1          
            if presupuesto.qtd_dependentes.to_i == 1
              self.desconto = 0
            elsif presupuesto.qtd_dependentes.to_i == 2
              self.desconto = 5
            elsif presupuesto.qtd_dependentes.to_i == 3
              self.desconto = 7
            end
          end

          produtos_composto = ProdutoComposicao.where(produto_id: self.produto_id)

          produtos_composto.each do |pc|
            get_prod_comp = Produto.find(pc.componente_id)
            PresupuestoProduto.create( presupuesto_id: self.presupuesto_id,
              produto_id: pc.componente_id,
              produto_nome: get_prod_comp.nome,
              moeda: self.moeda,
              data: self.data,
              tipo: 0,
              persona_dependente_nome: self.persona_dependente_nome,
              quantidade: self.quantidade.to_f,
              unitario_guarani: get_prod_comp.produtos_tabela_preco.last.preco_1_gs.to_f,
              unitario_dolar: get_prod_comp.produtos_tabela_preco.last.preco_1_us.to_f,
              total_guarani: get_prod_comp.produtos_tabela_preco.last.preco_1_gs.to_f * self.quantidade.to_f,
              total_dolar: get_prod_comp.produtos_tabela_preco.last.preco_1_us.to_f * self.quantidade.to_f
            )
          end
        end
      end
    end

    
    def finds
        if self.moeda == 0
         self.unitario_guarani =  self.unitario_dolar.to_f * presupuesto.cotacao.to_f
         self.total_guarani    =  self.total_dolar.to_f * presupuesto.cotacao.to_f
         self.unitario_real    =  self.unitario_guarani.to_f / presupuesto.cotacao_real.to_f
         self.total_real       =  self.total_guarani.to_f / presupuesto.cotacao_real.to_f
        elsif self.moeda == 1
         self.unitario_dolar   =  self.unitario_guarani.to_f / presupuesto.cotacao.to_f
         self.total_dolar      =  self.total_guarani.to_f / presupuesto.cotacao.to_f
         self.unitario_real    =  self.unitario_guarani.to_f / presupuesto.cotacao_real.to_f
         self.total_real       =  self.total_guarani.to_f / presupuesto.cotacao_real.to_f
        else
         self.unitario_guarani  =  self.unitario_real.to_f * presupuesto.cotacao_real.to_f
         self.total_guarani     =  self.total_real.to_f * presupuesto.cotacao_real.to_f
         self.unitario_dolar    =  self.unitario_guarani.to_f / presupuesto.cotacao.to_f
         self.total_dolar       =  self.total_guarani.to_f / presupuesto.cotacao.to_f
        end
    end
    def valide_total
      if presupuesto.moeda == 0
        if self.total_dolar <= 0
          errors[:base] << ( "Total no puesto esta ser 0 (Pulse ENTER en la quantidad para calcular)" )
        end
      end

      if presupuesto.moeda == 1
        if self.total_guarani <= 0
          errors[:base] << ( "Total no puesto esta ser 0 (Pulse ENTER en la quantidad para calcular)" )
        end
      end

      if presupuesto.moeda == 2
        if self.total_real <= 0
          errors[:base] << ( "Total no puesto esta ser 0 (Pulse ENTER en la quantidad para calcular)" )
        end
      end
    end
end

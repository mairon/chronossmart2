class OrdemCarga < ActiveRecord::Base

  belongs_to :pedido_traslado_doc
  belongs_to :produto
  belongs_to :pedido_traslado
  belongs_to :ordem_carga
  belongs_to :plano_de_conta
  before_save :finds

  after_save :create_gasto
  after_destroy :destroy_gasto

  def finds
     f = Frotum.find_by_id(self.frota_id)

    self.rodado_cv_id = f.rodado_cv_id
    self.rodado_cr_id = f.rodado_cr_id
    self.motorista_id = f.motorista_id
    self.proprietario_id = f.proprietario_id
  end


    def destroy_gasto
      compra = Compra.find_by_tabela_id(self.id, conditions: "tabela = 'ORDEM_CARGAS'")
      unless compra.blank?
        ComprasCusto.destroy_all("compra_id = #{compra.id}")
        ComprasFinanca.destroy_all("compra_id = #{compra.id}")
        compra.destroy
      end

    end

    def create_gasto

      compra = Compra.find_by_tabela_id(self.id, conditions: "tabela = 'ORDEM_CARGAS'")
      unless compra.blank?
        ComprasCusto.destroy_all("compra_id = #{compra.id}")
        ComprasFinanca.destroy_all("compra_id = #{compra.id}")
        compra.destroy
      end
      puts Moeda.last.dolar_venda.to_i
      puts Moeda.last.real_venda.to_f
      compra_g = Compra.create( 
        persona_id: self.motorista_id,
        moeda: self.moeda,
        unidade_id: pedido_traslado.unidade_id.to_i,
        tipo_compra: 1,
        total_guarani: self.valor_frete_gs,
        total_dolar: self.valor_frete_us,
        total_real: self.valor_frete_rs,
        data: self.data,
        competencia: self.data,
        documento_numero: self.cod_ext,
        documento_numero_01: '000',
        documento_numero_02: '000',
        tabela_id: self.id,
        fiscal: 0,
        tipo: 1,
        cota: 1,
        cotacao: Moeda.last.dolar_venda.to_i,
        cotacao_real: Moeda.last.real_venda.to_f,
        cotacao_rs_us:  Moeda.last.rs_us_venda.to_f,
        descricao: pedido_traslado.obs,
        plano_de_conta_id: self.plano_de_conta_id.to_i,
        forma_pago_id: 2,
        tabela: 'ORDEM_CARGAS')

        ComprasCusto.create(  
          :compra_id       => compra_g.id,
          :moeda           => compra_g.moeda,
          :unidade_id      => compra_g.unidade_id,
          :rodado_id      => self.rodado_cv_id,
          :plano_de_conta_id  => self.plano_de_conta_id,
          :ordem_carga_id  => self.id,
          :pedido_traslado_id  => pedido_traslado.id,
          :valor_us        => self.valor_frete_us,
          :valor_gs        => self.valor_frete_gs,
          :valor_rs        => self.valor_frete_rs,
          :data            => self.data,
        )

        ComprasFinanca.create( 
          compra_id:           compra_g.id,
          forma_pago_id:       2,
          tipo:                1,
          data:                self.data,
          tipo_compra:         1,
          descricao:           compra_g.descricao,
          documento_numero:    self.cod_ext,
          documento_numero_01: '000',
          documento_numero_02: '000',
          persona_id:          self.motorista_id,
          moeda:               self.moeda,
          cota:                1,
          valor_guarani:       compra_g.total_guarani,
          valor_dolar:         compra_g.total_dolar,
          valor_real:          compra_g.total_real,
          vencimento:          self.data 
        )       
  end
end

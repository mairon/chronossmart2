class ProvGasto < ActiveRecord::Base
	belongs_to :persona
	belongs_to :plano_de_conta
	after_create :gerador_cotas
	before_destroy :destroy_prov
  before_update :update_prov
  validates_presence_of :persona_id, :moeda, :dia_venc, :competencia

	def destroy_prov
		Proveedore.destroy_all("tabela = 'PROV_GASTOS' and tabela_id = #{self.id}")
    Compra.destroy_all("tabela = 'PROV_GASTOS' and tabela_id = #{self.id}")
	end

  def update_prov
    prov = Proveedore.where("tabela = 'PROV_GASTOS' and tabela_id = #{self.id}")
    cp = Compra.where("tabela = 'PROV_GASTOS' and tabela_id = #{self.id}")

    prov.each do |p|
      p.update_attributes(descricao: self.obs)
    end

    cp.each do |c|
      c.update_attributes(descricao: self.obs)
    end

  end

	def gerador_cotas
		#CALCULO COTACAO FATURA
		if self.moeda == 0
  		self.valor_gs     =  self.valor_us.to_f  * self.cotacao.to_f
      self.valor_rs     =  self.valor_gs.to_f  / self.cotacao_real.to_f
		elsif self.moeda == 1
      #guarani / dolar
      self.valor_us     =  self.valor_gs.to_f  / self.cotacao.to_f
      self.valor_rs     =  self.valor_gs.to_f  / self.cotacao_real.to_f
		else
      #real / guarani
  		self.valor_gs     =  self.valor_rs.to_f  * self.cotacao_real.to_f
      self.valor_us     =  self.valor_gs.to_f  / self.cotacao.to_f
		end


    nr_cota = 0
    data_atual = "#{self.ano_inicio}-#{self.mes_inicio.to_i}-#{self.dia_venc.to_i}".to_date

    self.competencia.to_i.times do
      nr_cota += 1

      compra_g = Compra.create( persona_id: self.persona_id,
        usuario_created: self.usuario_created,
        moeda: self.moeda,
        prov_gasto_id: self.id,
        unidade_id: self.unidade_id.to_i,
        tipo_compra: 1,
        total_guarani: self.valor_gs,
        total_dolar: self.valor_us,
        total_real: self.valor_rs,
        data: data_atual.to_date,
        competencia: data_atual.to_date,
        documento_numero: 'PROV' + self.id.to_s + '-' +  nr_cota.to_s,
        documento_numero_01: '000',
        documento_numero_02: '000',
        tabela_id: self.id,
        fiscal: 0,
        tipo: 0,
        cota: nr_cota,
        cotacao: self.cotacao.to_f,
        cotacao_real: self.cotacao_real.to_f,
        descricao: self.obs,
        plano_de_conta_id: self.plano_de_conta_id.to_i,
        tabela: 'PROV_GASTOS')


        venc = 0
        self.plano_de_conta.competencia.to_i.times do |rc|
          ComprasCusto.create(  
            :compra_id       => compra_g.id,
            :moeda           => compra_g.moeda,
            :unidade_id      => compra_g.unidade_id,
            :centro_custo_id => self.centro_custo_id,
            :rubro_grupo_id  => 0,
            :plano_de_conta_id => self.plano_de_conta_id.to_i,
            :valor_us        => (compra_g.total_dolar - compra_g.desconto_dolar) / self.plano_de_conta.competencia.to_i,
            :valor_gs        => (compra_g.total_guarani - compra_g.desconto_guarani) / self.plano_de_conta.competencia.to_i,
            :valor_rs        => (compra_g.total_real - compra_g.desconto_real) / self.plano_de_conta.competencia.to_i,
            :data            => compra_g.competencia.to_date.months_since(venc.to_i) - 1.month,

          )
          venc += 1
        end


      Proveedore.create( persona_id: self.persona_id,
        titulo: (Proveedore.last.id.to_i + 1),
        usuario_created: self.usuario_created,
        compra_id: compra_g.id,
        cota: nr_cota,
        moeda: self.moeda,
        plano_de_conta_id: self.plano_de_conta_id.to_i,
        centro_custo_id: self.centro_custo_id.to_i,
        unidade_id: self.unidade_id.to_i,
        liquidacao: 0,
        divida_guarani: self.valor_gs,
        divida_dolar: self.valor_us,
        divida_real: self.valor_rs,
        data: Time.now,
        documento_numero: 'PROV' + self.id.to_s + '-' +  nr_cota.to_s,
        documento_numero_01: '000',
        documento_numero_02: '000',
        tabela_id: self.id,
        tabela: 'PROV_GASTOS',
        cod_proc: self.id,
        sigla_proc: 'PG',
        conta_id: self.conta_id,
        descricao: self.obs,
        vencimento: data_atual.to_date,
        tot_cotas: self.competencia )
      data_atual = data_atual + 1.month

    end
  end
end

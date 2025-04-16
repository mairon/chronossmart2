class Contrato < ActiveRecord::Base
	belongs_to :persona
  belongs_to :centro_custo
  belongs_to :apartamento
  belongs_to :pedido_traslado
  belongs_to :terminal
	has_many :contrato_servicos, dependent: :destroy, order: 'id'
  has_many :contrato_custos, dependent: :destroy, order: 'id'
  accepts_nested_attributes_for :contrato_servicos, :reject_if => lambda { |a| a[:produto_id].blank? }, :allow_destroy => true
	after_create :gerador_cotas
	before_destroy :destroy_cli

  validates_presence_of :persona_id

	def destroy_cli
		Cliente.destroy_all("tabela = 'CONTRATOS' and tabela_id = #{self.id}")
	end

	def gerador_cotas

    if self.gerar_financas == true

      if self.periodicidade == 'MENSUAL'
        pr = 1.month
      elsif self.periodicidade == 'TRIMESTRAL'
        pr = 3.month
      elsif self.periodicidade == 'SEMESTRAL'
        pr = 6.month
      elsif self.periodicidade == 'ANUAL'
        pr = 12.month
      end

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

        nr_cota = self.cota_inicio.to_i
        data_atual = "#{Time.now.strftime("%Y")}-#{self.mes_inicio.to_i}-#{self.dia_venc.to_i}".to_date

        if self.tipo.to_i == 0
    	    val_gs = self.valor_gs
    	    val_us = self.valor_us
    	    val_rs = self.valor_rs
      	else
    	    val_gs = (self.valor_gs.to_f / self.competencia.to_i)
    	    val_us = (self.valor_us.to_f / self.competencia.to_i)
    	    val_rs = (self.valor_rs.to_f / self.competencia.to_i)
        end

        self.competencia.to_i.times do

          compra_financa = Cliente.create( persona_id: self.persona_id,
            titulo: (Cliente.last.id.to_i + 1),
            cota: nr_cota,
            unidade_id: self.unidade_id,
            moeda: self.moeda,
            liquidacao: 0,
            divida_guarani: val_gs,
            divida_dolar: val_us,
            divida_real: val_rs,
            data: Time.now,
            documento_numero: self.documento_numero.to_s,
            documento_numero_01: '000',
            documento_numero_02: '000',
            tabela_id: self.id,
            tabela: 'CONTRATOS',
            cod_proc: self.id,
            sigla_proc: 'CT',
            conta_id: self.conta_id,
            descricao: self.obs,
            tot_cotas: self.competencia.to_i,
            vencimento: data_atual.to_date,
            centro_custo_id: self.centro_custo_id )

          data_atual = data_atual + pr
          nr_cota += 1
        end
    end
  end


  def self.busca(params)
    unidade = "C.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      cond = "#{unidade} AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    else
      cond = "#{unidade}"
    end

    if params[:tipo] == "CODIGO"
      tipo = "C.ID"
      cond = "#{unidade} AND #{tipo} = #{params[:busca]} " unless params[:busca].blank?
    elsif params[:tipo] == "DOCUMENTO"
      cond = "#{unidade} AND C.DOCUMENTO_NUMERO ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?

    elsif params[:tipo] == "CENTRO CUSTOS"
      cond = "#{unidade} AND CC.NOME ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?

    elsif params[:tipo] == "VALOR"
      cond = "#{unidade} AND (SELECT SUM(CS.TOTAL_GS) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID) = #{params[:busca]}" unless params[:busca].blank?

    elsif params[:tipo] == "PARCELA"
      cond = "#{unidade} AND CC.competencia = #{params[:busca]} " unless params[:busca].blank?

    else
      tipo = "P.NOME"
      cond =  "#{unidade} AND #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    end

    sql = "SELECT C.ID,
                  C.MOEDA,
                  P.NOME AS PERSONA_NOME,
                  C.TIPO,
                  C.DOCUMENTO_NUMERO,
                  C.PERSONA_ID,
                  C.DIA_VENC,
                  C.competencia,
                  C.obs,
                  CC.NOME AS CENTRO_CUSTO_NOME,
                  (SELECT SUM(CS.TOTAL_RS) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID) AS valor_rs,
                  (SELECT SUM(CS.TOTAL_US) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID) AS valor_us,
                  (SELECT SUM(CS.TOTAL_GS) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID) AS valor_gs,
                  (SELECT SUM(CS.QUANTIDADE) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID) AS SUM_QTD_CONTRATO_SERVICOS

            FROM CONTRATOS C

            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID

            INNER JOIN CENTRO_CUSTOS CC
            ON C.CENTRO_CUSTO_ID = CC.ID

          WHERE #{cond}
          ORDER BY C.ID DESC
          "
    Contrato.paginate_by_sql(sql, page: params[:page], :per_page => 25)
  end

end

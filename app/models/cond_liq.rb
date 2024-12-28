class CondLiq < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	validates_presence_of :persona_id, :condicional_id
  validates_uniqueness_of :condicional_id, message: " ja cadastrado."
 
	belongs_to :persona
  belongs_to :condicional
	has_many :cond_liq_docs,   :order => 1, :dependent => :destroy
	has_many :cond_liq_produtos,   :order => 1, :dependent => :destroy
  has_many :cond_liq_vendidos,   :order => 1, :dependent => :destroy
	has_many :cond_liq_financas,   :order => 1, :dependent => :destroy
  has_many :vendas, :dependent => :destroy
  before_create :finds
  before_destroy :update_status_condicional

  def update_status_condicional
    cond = Condicional.find_by_id(self.condicional_id)
    cond.update_attributes(status: 0)
  end
  
  def finds
    cond = Condicional.find_by_id(self.condicional_id);
    self.vendedor_id  = cond.vendedor_id unless self.condicional_id.blank?
    self.moeda        = cond.moeda unless self.condicional_id.blank?

    cond = Condicional.find_by_id(self.condicional_id)

    cond.update_attributes(status: 1)
	end

  def self.filtro_busca(params)
    unidade = "CL.UNIDADE_ID = #{params[:unidade]}"

    unless params[:inicio].blank?
    cond =  "#{unidade} AND CL.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' " 
    else
      cond =  "#{unidade}"
    end

    if params[:tipo] == "CODIGO"
      tipo = "CL.ID"
      cond =  "#{unidade} AND #{tipo} = '#{params[:busca]}' " unless params[:busca].blank?
    elsif params[:tipo] == "NOMBRE"
      tipo = "P.NOME"
      cond =  "#{unidade} AND #{tipo} ILIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    end

    sql = "SELECT CL.ID,
                  CL.DATA,
                  P.NOME AS CLIENTE, 
                  V.NOME AS VENDEDOR,
                  CL.MOEDA,
                  CL.STATUS,
                  CL.CONDICIONAL_ID,
                  COALESCE((SELECT SUM(C.QUANTIDADE) FROM CONDICIONAL_PRODUTOS C WHERE C.CONDICIONAL_ID = CL.CONDICIONAL_ID),0) + COALESCE((SELECT SUM(C.QUANTIDADE) FROM CONDICIONAL_PRODUTOS C INNER JOIN COND_LIQ_DOCS CLD ON CLD.CONDICIONAL_ID = C.CONDICIONAL_ID WHERE CLD.COND_LIQ_ID = CL.ID),0) AS QTD_COND,                  
                  COALESCE((SELECT SUM(CP.QUANTIDADE) FROM COND_LIQ_PRODUTOS CP WHERE CP.COND_LIQ_ID = CL.ID ),0) AS DEVOLVIDO,
                  COALESCE((SELECT SUM(CV.QUANTIDADE) FROM COND_LIQ_VENDIDOS CV WHERE CV.COND_LIQ_ID = CL.ID ),0) AS VENDIDO
            FROM COND_LIQS CL
            INNER JOIN PERSONAS P
            ON P.ID = CL.PERSONA_ID
            LEFT JOIN PERSONAS V
            ON V.ID = CL.VENDEDOR_ID
            WHERE #{cond}
            ORDER BY CL.DATA DESC"


    self.find_by_sql(sql)

  end


  def self.gerador_cotas(params)
    cota = 1
    venc = 0
    cp = CondLiq.find_by_id(params[:id])
    if cp.moeda.to_i == 0
      valor_us = params[:valor_us].to_f / params[:cotas].to_i
      valor_gs = (params[:valor_us].to_f / params[:cotas].to_i) * cp.cotacao.to_f
      valor_rs = valor_gs.to_f / cp.cotacao_real.to_f
    elsif cp.moeda.to_i == 1
      valor_gs = params[:valor_gs].to_f / params[:cotas].to_i
      valor_us = (params[:valor_us].to_f / params[:cotas].to_i)
      valor_rs = (params[:valor_rs].to_f  / params[:cotas].to_i)
    else
      valor_rs = params[:valor_rs].to_f / params[:cotas].to_i
      valor_gs = (params[:valor_rs].to_f / params[:cotas].to_i) * cp.cotacao_real.to_f
      valor_us = (params[:valor_rs].to_f / params[:cotas].to_i) / cp.cotacao_real.to_f
    end
    params[:cotas].to_i.times do
      CondLiqFinanca.create( :cond_liq_id           => params[:id],
                            :tipo                => 1,
                            :data                => cp.data,
                            :fatura              => params[:fatura],
                            :documento_numero_01 => params[:documento_numero_01],
                            :documento_numero_02 => params[:documento_numero_02],
                            :documento_numero    => params[:documento_numero],
                            :persona_id      => cp.persona_id,
                            :persona_nome    => cp.persona.nome,
                            :moeda               => cp.moeda,
                            :cota                => cota,
                            :valor_gs       => valor_gs.to_f,
                            :valor_us         => valor_us.to_f,
                            :valor_rs          => valor_rs.to_f,
                            :vencimento          => params[:venci].to_date.months_since(venc.to_i) )
      cota += 1
      venc += 1
    end

  end

end

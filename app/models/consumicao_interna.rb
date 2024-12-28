class ConsumicaoInterna < ActiveRecord::Base
  has_many :consumicao_interna_produtos,   :order => 'id desc', :dependent => :destroy
  belongs_to :persona
  belongs_to :rodado
  belongs_to :centro_custo

  validates_presence_of :tipo_economico

  def self.filtro_busca(params)

    unidade = "V.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      data = "AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "V.ID"
        cond = "AND #{tipo} = #{params[:busca]} "     
      else
        tipo = "P.NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT V.ID,
                  V.USUARIO_CREATED,
                  V.DATA,
                  V.MOEDA,
                  V.CONCEPTO,
                  V.TIPO_ECONOMICO,
                  P.NOME AS PERSONA_NOME,
                  M.NOME AS MOTIVO_NOME,
                  (SELECT SUM(VP.QUANTIDADE) FROM CONSUMICAO_INTERNA_PRODUTOS VP WHERE VP.CONSUMICAO_INTERNA_ID = V.ID ) AS QTD
            FROM CONSUMICAO_INTERNAS V

            LEFT JOIN PERSONAS P
            ON P.ID = V.PERSONA_ID

            LEFT JOIN MOTIVOS M
            ON M.ID = V.MOTIVO_ID

            WHERE  #{unidade} #{data} #{cond}
            ORDER BY V.DATA DESC, V.ID DESC"
      ConsumicaoInterna.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end


end

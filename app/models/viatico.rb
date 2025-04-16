class Viatico < ActiveRecord::Base
  belongs_to :persona
  belongs_to :conta
  belongs_to :forma_pago

  def self.filtro_busca_viatico(params)

    unidade = "V.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      data = "AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "V.ID"
        cond = "AND #{tipo} = #{params[:busca]} "
      else
        tipo = "V.PERSONA_NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT V.ID,
                  V.USUARIO_CREATED,
                  V.DATA,
                  V.PERSONA_NOME,
                  V.MOEDA,
                  V.OBS,
                  V.VALOR_GS,
                  V.VALOR_RS,
                  V.VALOR_US,
                  C.NOME AS CONTA_NOME,
                  FP.NOME AS FORMA_PAGO_NOME,
                  (SELECT SUM(AT.COBRO_DOLAR) FROM CLIENTES AT WHERE AT.UNIDADE_ID = V.UNIDADE_ID AND AT.PERSONA_ID = V.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = 'V00' AND AT.DOCUMENTO_NUMERO_02 = '000' AND AT.DOCUMENTO_NUMERO = CAST(V.ID AS VARCHAR ) AND AT.COTA = 1 AND AT.LIQUIDACAO = 0) AS APLICADO_US,
                  (SELECT SUM(AT.COBRO_GUARANI) FROM CLIENTES AT WHERE AT.UNIDADE_ID = V.UNIDADE_ID AND AT.PERSONA_ID = V.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = 'V00' AND AT.DOCUMENTO_NUMERO_02 = '000' AND AT.DOCUMENTO_NUMERO = CAST(V.ID AS VARCHAR ) AND AT.COTA = 1 AND AT.LIQUIDACAO = 0) AS APLICADO_GS,
                  (SELECT SUM(AT.COBRO_REAL) FROM CLIENTES AT WHERE AT.UNIDADE_ID = V.UNIDADE_ID AND AT.PERSONA_ID = V.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = 'V00' AND AT.DOCUMENTO_NUMERO_02 = '000' AND AT.DOCUMENTO_NUMERO = CAST(V.ID AS VARCHAR ) AND AT.COTA = 1 AND AT.LIQUIDACAO = 0) AS APLICADO_RS
            FROM VIATICOS V

            LEFT JOIN CONTAS C
            ON C.ID = V.CONTA_ID

            INNER JOIN FORMA_PAGOS FP
            ON FP.ID = V.FORMA_PAGO_ID

            WHERE  #{unidade} #{data} #{cond}
            ORDER BY V.DATA DESC, V.ID DESC"
      Viatico.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end
end

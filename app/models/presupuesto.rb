class Presupuesto < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :presupuesto_produtos, order: 'grupo_id, id', :dependent => :destroy
  has_many :presupuesto_cotas, :dependent => :destroy
  has_one :contrato
  validates_presence_of :cotacao,:persona_id, :vendedor_id
  belongs_to :colecao
  belongs_to :persona
  belongs_to :sub_grupo
  belongs_to :plano
  belongs_to :tabela_preco
  belongs_to :prazo

  #after_save :gera_tarefa
  fields = CustomField.pluck(:internal_name)
  serialize :custom_fields, JSON
  store_accessor :custom_fields, [ fields ]

  puts "================ #{fields}"
  def block_data
    #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
    if ( self.data.to_date == self.prazo_entrega.to_date  )
      errors.add( :data,"La Fecha no puede ser igual a Prevision de Entraga!" )
    end
  end

  def self.filtro_busca(params)
    unidade   = "P.UNIDADE_ID = #{params[:unidade]}"
    st = "AND P.STATUS = '#{params[:status]}' " unless params[:status].blank?
    unless params[:inicio].blank?
      cond =  " #{unidade} AND P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    else
      cond =  " #{unidade}"
    end
    if params[:tipo] == "CODIGO"
      tipo = "P.ID"
      cond =  " #{unidade} AND #{tipo} = ? ","#{params[:busca]}" unless params[:busca].blank?
    elsif params[:tipo] == "NOMBRE"
      tipo = "P.PERSONA_NOME"
      cond =  " #{unidade} AND  #{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    elsif params[:tipo] == "VENDEDOR"
      tipo = "V.NOME"
      cond =  " #{unidade} AND  #{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?

    end
    sql = "SELECT  P.ID,
                   P.ORIGEM,
                   P.DATA,
                   V.NOME AS VENDEDOR,
                   I.ID AS INDICADOR,
                   V.ID AS VENDEDOR_ID,
                   P.PERSONA_NOME,
                   P.PERSONA_ID,
                   P.DOCUMENTO_NUMERO,
                   P.STATUS,
                   P.TABELA_PRECO_ID,
                   TP.NOME AS TABELA_PRECO_NOME,
                   PL.CONDICAO,
                   P.PLANO_ID,
                   COALESCE((SELECT C.ID FROM CONTRATOS C WHERE C.PRESUPUESTO_ID = P.ID LIMIT 1),0) CONTRATO_ID,
                   COALESCE((SELECT SUM(PP.QUANTIDADE) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) QTD,
                   COALESCE((SELECT SUM(PP.TOTAL_GUARANI) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) TOTAL_GS,
                   COALESCE((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_ID = P.ID),0) FACT,
                   COALESCE((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE PRODUTO_ID IN (SELECT PP.PRODUTO_ID FROM PRESUPUESTO_PRODUTOS PP WHERE PP.STATUS = 0 AND PP.PRESUPUESTO_ID = P.ID)),0) AS DISP,
                   (PE.CHAPA || ' - ' || PE.MODELO ||  ' - ' ||  PE.MARCA || ' - ' || PE.COR ) AS EQUIPO_NOME
                  FROM PRESUPUESTOS P
                  LEFT JOIN PERSONAS V
                  ON P.VENDEDOR_ID = V.ID

                  LEFT JOIN TABELA_PRECOS TP
                  ON P.TABELA_PRECO_ID = TP.ID

                  LEFT JOIN PERSONA_RODADOS PE
                  ON P.PERSONA_RODADO_ID = PE.ID

                  LEFT JOIN PLANOS PL
                  ON P.PLANO_ID = PL.ID

                  LEFT JOIN PERSONAS I
                  ON P.INDICADOR_ID = I.ID
                  WHERE #{cond} #{st}
                  ORDER BY P.DATA DESC, P.ID DESC"
    Presupuesto.find_by_sql(sql)
  end
end

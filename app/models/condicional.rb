class Condicional < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to :persona
  belongs_to :deposito
  has_many :condicional_produtos, :dependent => :destroy, :order => 'id desc'

  validates_presence_of :cotacao,
                        :persona_id,
                        :tabela_preco

  validates :cotacao, :numericality => { :greater_than => 0.01 }
  #validates :vendedor_id, numericality: { only_integer: true }
  validates :unidade_id, numericality: { only_integer: true }

  before_validation :finds

  def finds
  	self.tabela_preco = persona.cliente
    self.persona_nome = persona.nome
    if self.unidade_id.to_i ==  1
      self.tabela_preco = 1
    end
  end

  def self.filtro_busca(params)
    unless params[:inicio].blank?
      dt = " AND OS.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    if params[:tipo] == "CODIGO"
      tipo = "OS.ID"
      cond = "AND #{tipo} = #{params[:busca]} " unless params[:busca].blank?
    elsif params[:tipo] == "RESPONSAVEL"
      tipo = "RP.NOME"
      cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    elsif params[:tipo] == "RT"
      tipo = "OS.RT"
      cond =  "AND #{tipo} = '#{params[:busca]}' " unless params[:busca].blank?

    else
      tipo = "P.NOME"
      cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    end
    status = "AND OS.STATUS = '#{params[:status]}' " if params[:status] != ''
    sql = "SELECT OS.ID,
                  OS.DATA,
                  OS.MOEDA,
                  P.NOME AS PERSONA_NOME,
                  RP.NOME AS RESPONSAVEL_NOME,
                  OS.STATUS,
                  U.USUARIO_NOME,
                  OS.usuario_created,
                  COALESCE((SELECT SUM(OSP.QUANTIDADE) FROM CONDICIONAL_PRODUTOS OSP WHERE OSP.CONDICIONAL_ID = OS.ID AND OSP.STATUS = TRUE),0) - (COALESCE((SELECT SUM(OSP.QUANTIDADE) FROM CONDICIONAL_PRODUTOS OSP WHERE OSP.CONDICIONAL_ID = OS.ID AND OSP.STATUS = FALSE),0)) AS QTD,
                  COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_US) FROM CONDICIONAL_PRODUTOS OSP WHERE OSP.CONDICIONAL_ID = OS.ID AND OSP.STATUS = TRUE),0) - (COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_US) FROM CONDICIONAL_PRODUTOS OSP WHERE OSP.CONDICIONAL_ID = OS.ID AND OSP.STATUS = FALSE),0)) AS TOT_US, 
                  COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_GS) FROM CONDICIONAL_PRODUTOS OSP WHERE OSP.CONDICIONAL_ID = OS.ID AND OSP.STATUS = TRUE),0) - (COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_GS) FROM CONDICIONAL_PRODUTOS OSP WHERE OSP.CONDICIONAL_ID = OS.ID AND OSP.STATUS = FALSE),0)) AS TOT_GS
          FROM CONDICIONALS OS
          
          INNER JOIN PERSONAS P
          ON P.ID = OS.PERSONA_ID
          
          INNER JOIN PERSONAS RP
          ON RP.ID = OS.VENDEDOR_ID

          LEFT JOIN USUARIOS U
          ON U.ID = OS.USUARIO_CREATED

          WHERE OS.UNIDADE_ID = #{params[:unidade]} #{dt} #{cond} #{status}
          ORDER BY OS.DATA DESC, OS.ID DESC
          "
    self.paginate_by_sql(sql, page: params[:page], :per_page => 25)
  end

  def self.saldo(params)

      sql = "SELECT CP.PRODUTO_ID,
                    MAX(CP.ID) AS ID,
                    MAX(P.FABRICANTE_COD) AS FABRICANTE_COD,
                    MAX('') AS TAMANHO,
                    MAX('') AS COR,
                    MAX(P.BARRA) AS BARRA,
                    MAX(P.NOME) NOME,
                    MAX(CP.VALOR_GS) AS VALOR_GS,
                    MAX(CP.VALOR_US) AS VALOR_US,
                    SUM(CP.QUANTIDADE) AS SAIDA,
                    coalesce((SELECT SUM(CE.QUANTIDADE) FROM CONDICIONAL_PRODUTOS CE WHERE CE.PRODUTO_ID = CP.PRODUTO_ID AND CE.STATUS = FALSE AND CE.CONDICIONAL_ID = #{params[:id]}),0) AS ENTRADA
      FROM CONDICIONAL_PRODUTOS CP
      INNER JOIN PRODUTOS P
      ON P.ID = CP.PRODUTO_ID
      WHERE CP.CONDICIONAL_ID = #{params[:id]}
      AND CP.STATUS = TRUE
      GROUP BY 1
      HAVING
      (SUM(CP.QUANTIDADE) - coalesce((SELECT SUM(CE.QUANTIDADE) FROM CONDICIONAL_PRODUTOS CE WHERE CE.PRODUTO_ID = CP.PRODUTO_ID AND CE.STATUS = FALSE AND CE.CONDICIONAL_ID = #{params[:id]}),0)) > 0"


    asql = "SELECT P.FABRICANTE_COD,
                  '' AS TAMANHO,
                  '' AS COR,
                  P.NOME,
                  OS.VALOR_GS,
                  OS.VALOR_US,
                  OS.QUANTIDADE AS SAIDA,
                  OS.PRODUTO_ID,
                  COALESCE((SELECT SUM(E.QUANTIDADE) FROM CONDICIONAL_PRODUTOS E WHERE E.PRODUTO_ID = OS.PRODUTO_ID AND E.STATUS = FALSE AND E.CONDICIONAL_ID = #{params[:id]} ),0) AS ENTRADA
            FROM CONDICIONAL_PRODUTOS OS

            INNER JOIN PRODUTOS P

            ON P.ID = OS.PRODUTO_ID
            WHERE OS.CONDICIONAL_ID = #{params[:id]}
            AND OS.STATUS = TRUE"

    OrdemServ.find_by_sql(sql)
  end

end

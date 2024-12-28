class OrdemServ < ActiveRecord::Base
  belongs_to :persona
  validates_presence_of :persona_id
  has_many :ordem_serv_prods,  :order => 'id desc', :dependent => :destroy
  has_many :ordem_serv_files,  :order => 'id desc', :dependent => :destroy
  belongs_to :persona_rodado


  def self.filtro(params)
    unidade = "OS.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      cond = "#{unidade} AND OS.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    else
      cond = "#{unidade}"
    end

    if params[:tipo] == "CODIGO"
      tipo = "OS.ID"
      cond = "#{unidade} AND #{tipo} = #{params[:busca]} " unless params[:busca].blank?
    elsif params[:tipo] == "RESPONSAVEL"
      tipo = "RP.NOME"
      cond =  "#{unidade} AND #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    elsif params[:tipo] == "RT"
      tipo = "OS.RT"
      cond =  "#{unidade} AND #{tipo} = '#{params[:busca]}' " unless params[:busca].blank?

    else
      tipo = "P.NOME"
      cond =  "#{unidade} AND #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    end
    status = "AND OS.STATUS = '#{params[:status]}'" if params[:status] != 'TODOS'
    sql = "SELECT OS.ID,
                  OS.RT,
					        OS.DATA,
					        OS.MOEDA,
					        P.NOME AS PERSONA_NOME,
					        RP.NOME AS RESPONSAVEL_NOME,
					        OS.STATUS,
					        U.USUARIO_NOME,
					        OS.usuario_created,
                  OS.GARANTIA,
                  OS.luz_display,
                  COALESCE((SELECT SUM(OSP.QUANTIDADE) FROM ORDEM_SERV_PRODS OSP WHERE OSP.ORDEM_SERV_ID = OS.ID AND OSP.STATUS = TRUE),0) - (COALESCE((SELECT SUM(OSP.QUANTIDADE) FROM ORDEM_SERV_PRODS OSP WHERE OSP.ORDEM_SERV_ID = OS.ID AND OSP.STATUS = FALSE),0)) AS QTD,
                  COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_US) FROM ORDEM_SERV_PRODS OSP WHERE OSP.ORDEM_SERV_ID = OS.ID AND OSP.STATUS = TRUE),0) - (COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_US) FROM ORDEM_SERV_PRODS OSP WHERE OSP.ORDEM_SERV_ID = OS.ID AND OSP.STATUS = FALSE),0)) AS TOT_US, 
                  COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_GS) FROM ORDEM_SERV_PRODS OSP WHERE OSP.ORDEM_SERV_ID = OS.ID AND OSP.STATUS = TRUE),0) - (COALESCE((SELECT SUM(OSP.QUANTIDADE * OSP.VALOR_GS) FROM ORDEM_SERV_PRODS OSP WHERE OSP.ORDEM_SERV_ID = OS.ID AND OSP.STATUS = FALSE),0)) AS TOT_GS
					FROM ORDEM_SERVS OS
					INNER JOIN PERSONAS P
					ON P.ID = OS.PERSONA_ID
					INNER JOIN PERSONAS RP
					ON RP.ID = OS.RESPONSAVEL_ID

					LEFT JOIN USUARIOS U
					ON U.ID = OS.USUARIO_CREATED

          WHERE #{cond} #{status}
          ORDER BY OS.DATA DESC, OS.ID DESC
          "
    OrdemServ.paginate_by_sql(sql, page: params[:page], :per_page => 25)
  end
end

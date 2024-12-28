class PedidoCompra < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }

  has_many :pedido_compra_produtos, order: 'id desc', :dependent => :destroy
  has_many :pedido_compra_financas, order: 'id desc', :dependent => :destroy
  belongs_to :colecao
  belongs_to :sub_grupo
  belongs_to :persona
  validates_presence_of :cotacao, :persona_id
  before_save :finds
  before_create :get_cambio

  def finds
    per = Persona.find_by_id(self.persona_id,:select => 'id,nome')
    self.persona_nome = per.nome unless self.persona_id.blank?

    func = Persona.find_by_id(self.requerente_id,:select => 'id,nome')
    self.requerente_nome = func.nome unless self.requerente_id.blank?

    trans = Persona.find_by_id(self.transportadora_id,:select => 'id,nome')
    self.transportadora_nome = trans.nome unless self.transportadora_id.blank?

    if self.documento_numero == ''
      max_number = (PedidoCompra.last.id.to_i + 1)
      self.documento_numero = ('9' + max_number.to_s).to_s.rjust(6,'0')
    end
  end
  def get_cambio
    md =  Moeda.last(:select => 'dolar_compra,rs_us_compra,real_compra,ps_gs_compra')
    self.cotacao = md.dolar_compra
    self.cotacao_real = md.real_compra

  end

  def self.filtro_busca_pedido(params)
      unidade = "unidade_id = #{params[:unidade]}"
      sub_g = "sub_grupo_id = #{params[:sub_g]} and " unless params[:sub_g].blank?

    if params[:seta].to_s == "0"
      if params[:inicio] != ''
        cond =  "#{sub_g} #{unidade} AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"
      else
        cond =  "#{sub_g} #{unidade}"
      end
    else
      if params[:tipo] == "CODIGO"
        cond =  "#{sub_g} #{unidade} AND id = ? ","#{params[:busca]}" unless params[:busca].blank?
      else
        cond =  "#{sub_g} #{unidade} AND persona_nome LIKE ?","%#{params[:busca]}%" unless params[:busca].blank?
      end
    end
    self.all(:select => "tipo_pedido,id,data,data_entrega,persona_nome,status,colecao_id,sub_grupo_id",:conditions => cond ,:order => 'data desc,id')
  end


  def self.disponibilidade_stock(params)
    params["status"] = '0'
    #GRUPO
    sub_grupo = "AND P.sub_grupo_id = #{params[:sub_grupo_id]}"
    #COLECAO
    colecao = "AND P.colecao_id = #{params[:colecao_id]}" unless params[:colecao_id].blank?
    #DEPOSITO
    deposito = "AND S.deposito_id = #{params[:deposito]}"
    st  = "COALESCE((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.PRODUTO_ID = S.PRODUTO_ID AND S.PRODUTOS_GRADE_ID = PG.ID #{deposito}),0)"
    p_v = "COALESCE((SELECT SUM(PP.QUANTIDADE) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.DATA <= '#{params[:pedido_venda_ate].to_date}' AND PP.PRODUTO_ID = PG.PRODUTO_ID AND PP.PRODUTOS_GRADE_ID = PG.ID),0)"
    p_c = "COALESCE((SELECT SUM(PC.QUANTIDADE) FROM PEDIDO_COMPRA_PRODUTOS PC WHERE  PC.DATA <= '#{params[:pedido_venda_ate].to_date}' AND PC.PRODUTO_ID = PG.PRODUTO_ID AND PC.PRODUTOS_GRADE_ID = PG.ID),0)"
    status = "AND (((#{st} + #{p_c}) - #{p_v}) < 0)"

    sql = "SELECT  PG.ID AS PRODUTOS_GRADE_ID,
                   P.FABRICANTE_COD,
                   P.ID AS PRODUTO_ID,
                   P.NOME AS PRODUTO_NOME,
                   P.CLASE_ID,
                   P.GRUPO_ID,
                   P.SUB_GRUPO_ID,
                   P.COLECAO_ID,
                   C.ID AS COR_ID,
                   C.NOME AS COR_NOME,
                   T.ID AS TAMANHO_ID,
                   T.NOME AS TAMANHO_NOME,
                   P.CUSTO_BASE_GS,
                   P.CUSTO_BASE_US,
                   P.CUSTO_BASE_RS,
                   COALESCE((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.PRODUTO_ID = S.PRODUTO_ID AND S.PRODUTOS_GRADE_ID = PG.ID #{deposito}),0) AS STOCK,
                   COALESCE((SELECT SUM(PP.QUANTIDADE) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.DATA <= '#{params[:pedido_venda_ate].to_date}' AND PP.PRODUTO_ID = PG.PRODUTO_ID AND PP.PRODUTOS_GRADE_ID = PG.ID),0) AS P_VENDA,
                   COALESCE((SELECT SUM(PC.QUANTIDADE) FROM PEDIDO_COMPRA_PRODUTOS PC WHERE PC.DATA <= '#{params[:pedido_venda_ate].to_date}' AND  PC.PRODUTO_ID = PG.PRODUTO_ID AND PC.PRODUTOS_GRADE_ID = PG.ID),0) AS P_COMPRA
             FROM PRODUTOS_GRADES PG
             INNER JOIN PRODUTOS P
             ON PG.PRODUTO_ID = P.ID

             LEFT JOIN CORS C
             ON PG.COR_ID = C.ID

             LEFT JOIN TAMANHOS T
             ON PG.TAMANHO_ID = T.ID

             WHERE PG.ID > 0  #{sub_grupo} #{colecao} #{status}
             "

    PedidoCompra.find_by_sql( sql )
  end
end


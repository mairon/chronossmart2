class Pago < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :pagos_detalhes,   :order => 1, :dependent => :destroy
  has_many :pagos_financas,   :order => 1, :dependent => :destroy
  has_many :pagos_adelantos,   :order => 1, :dependent => :destroy

  belongs_to :persona

  validates_presence_of :cotacao,
                        :persona_nome,
                        :persona_id


  def self.filtro(params)
    unidade = "C.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      data = "AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "C.ID"
        cond = "AND #{tipo} = #{params[:busca]} "
      else
        tipo = "C.PERSONA_NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT C.ID,
                  C.DATA,
                  C.MOEDA,
                  C.PERSONA_NOME,
                  C.USUARIO_CREATED,
                  U.USUARIO_NOME,
                  (SELECT SUM(CD.PAGO_GUARANI) FROM PAGOS_DETALHES CD WHERE CD.PAGO_ID = C.ID ) AS VALOR_GS,
                  (SELECT SUM(CD.PAGO_DOLAR) FROM PAGOS_DETALHES CD WHERE CD.PAGO_ID = C.ID ) AS VALOR_US,
                  (SELECT SUM(CD.PAGO_REAL) FROM PAGOS_DETALHES CD WHERE CD.PAGO_ID = C.ID ) AS VALOR_RS,
                  (SELECT CF.descricao FROM PAGOS_FINANCAS CF WHERE CF.PAGO_ID = C.ID LIMIT 1 ) AS DESCRICAO,
                  (SELECT CF.CONTA_NOME FROM PAGOS_FINANCAS CF WHERE CF.PAGO_ID = C.ID LIMIT 1 ) AS CONTA_NOME,
                  BF.STATUS AS STATUS_BLOCK
            FROM PAGOS C
            LEFT JOIN USUARIOS U
            ON C.USUARIO_CREATED = U.ID
            LEFT JOIN BLOCK_FINANCEIROS BF
            ON date_part('month', C.DATA) = date_part('month', BF.PERIODO)
            AND date_part('year', C.DATA) = date_part('year', BF.PERIODO)
          WHERE #{unidade} #{data} #{cond}
          ORDER BY C.DATA DESC, C.ID DESC
          "
    Pago.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end

  before_update :finds

  def finds       #
      @conta = Conta.find_by_id(self.conta_id);
      self.conta_nome = @conta.nome.to_s unless self.conta_id.blank?

      @documento = Documento.find_by_id(self.documento_id);
      self.documento_nome = @documento.nome.to_s unless self.documento_id.blank?
  end
end

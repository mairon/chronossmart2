class Ingresso < ActiveRecord::Base
  
  validates :cotacao,
            :conta_id,
            :valor_dolar,
            :valor_guarani, 
            :concepto,
            :presence => true

  validates :cotacao, :numericality =>  { :greater_than => 0 }

  before_save :finds

  def finds
    conta = Conta.find_by_id(self.conta_id)
    self.conta_nome = conta.nome.to_s unless self.conta_id.blank?
    self.moeda = conta.moeda.to_s unless self.conta_id.blank?
  end

    def self.filtro_ingreso(params)
        unidade = "unidade_id = #{params[:unidade]} AND "
        data  = "data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?

        if params[:tipo] == "CODIGO"
          tipo = "id"
          busca = "AND E.ID = #{params[:busca]}" unless params[:busca].blank?
        else
          tipo = "conta_nome"
          busca = "AND C.NOME ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?
        end

        sql = "SELECT E.ID,
                      E.DATA,
                      E.VALOR_GUARANI,
                      E.VALOR_DOLAR,
                      E.VALOR_REAL,
                      E.MOEDA,
                      E.CHEQUE,
                      E.CONCEPTO,
                      E.USUARIO_CREATED,
                      U.USUARIO_NOME AS USUARIO_NOME,
                      C.NOME AS CONTA_NOME
                FROM INGRESSOS E
                INNER JOIN CONTAS C
                ON C.ID = E.CONTA_ID

                LEFT JOIN USUARIOS U
                ON U.ID = E.USUARIO_CREATED

                WHERE E.UNIDADE_ID = #{params[:unidade]} #{busca}
                ORDER BY E.DATA DESC,ID DESC


                    "


        Ingresso.paginate_by_sql(sql, page: params[:page], :per_page => 25)
    end


end

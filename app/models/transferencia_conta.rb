class TransferenciaConta < ActiveRecord::Base
    audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
    has_many :transferencia_contas_detalhes ,:dependent => :destroy
    validates_presence_of :cotacao, :valor_dolar,
                          :valor_guarani, :concepto

    before_save :finds
    def finds

        @ingreso = Conta.find_by_id(self.ingreso_id);
        self.ingreso_nome = @ingreso.nome.to_s;
        self.ingreso_moeda = @ingreso.moeda

        @destino = Conta.find_by_id(self.destino_id);
        self.destino_nome = @destino.nome.to_s;
        self.destino_moeda =  @destino.moeda
        per = Persona.find_by_id(self.persona_id);
        self.persona_nome = per.nome.to_s unless  self.persona_id.blank?;
        if self.deposito == 3
          if self.concepto == ''
            self.concepto = 'Viatico ' << self.persona_nome.to_s << ' N.: ' << self.id.to_s
          end 
        end 
    end

    def self.filtro(params)
        unidade = "T.UNIDADE_ID = #{params[:unidade]}"
        unless params[:inicio].blank?
            dt = "and T.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"
        end

        if params[:tipo] == "CODIGO"
            tipo = "T.ID"
            cond =  "and #{tipo} = '%#{params[:busca]}%' " unless params[:busca].blank?
        elsif params[:tipo] == "CONTA ORIGEM"
            tipo = "T.INGRESO_NOME"
            cond =  "and #{tipo} ILIKE '%#{params[:busca]}%'" unless params[:busca].blank?
        else
            tipo = "T.DESTINO_NOME"
            cond =  "and #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?

        end
    sql = "SELECT T.ID,
                  T.DATA,
                  T.PERSONA_NOME,
                  T.INGRESO_NOME,
                  T.DESTINO_NOME,
                  T.CONCEPTO,
                  T.DEPOSITO,
                  coalesce((SELECT SUM(TD.SAIDA_DOLAR) FROM TRANSFERENCIA_CONTAS_DETALHES TD WHERE TD.TRANSFERENCIA_CONTA_ID = T.ID ),0) AS VALOR_US,
                  coalesce((SELECT SUM(TD.SAIDA_GUARANI) FROM TRANSFERENCIA_CONTAS_DETALHES TD WHERE TD.TRANSFERENCIA_CONTA_ID = T.ID ),0) AS VALOR_GS,
                  coalesce((SELECT SUM(TD.SAIDA_REAL) FROM TRANSFERENCIA_CONTAS_DETALHES TD WHERE TD.TRANSFERENCIA_CONTA_ID = T.ID ),0) AS VALOR_RS
            FROM TRANSFERENCIA_CONTAS T
            WHERE #{unidade} #{cond} #{dt}
            ORDER BY 2 DESC, 1 DESC
            "


        self.paginate_by_sql(sql, :page => params[:page], :per_page => 25)
    end

end

class Frotum < ActiveRecord::Base

  def self.busca_frota(params)		
    unidade = "V.UNIDADE_ID = #{params[:unidade]}"
		id            = "AND F.ID = #{params[:codigo]}" unless params[:codigo].blank?
		tipo          = "AND F.tipo = #{params[:tipo]}" unless params[:tipo].blank?
		proprietario  = "AND PP.NOME ILIKE '%#{params[:proprietario_id]}%' " unless params[:proprietario_id].blank?
		motorista     = "AND PM.NOME ILIKE '%#{params[:motorista_id]}%' " unless params[:motorista_id].blank?
		rodado_cavalo = "AND RC.PLACA ILIKE '%#{params[:rodado_cavalo]}%' " unless params[:rodado_cavalo].blank?
		rodado_carreta = "AND RR.PLACA ILIKE '%#{params[:rodado_carreta]}%' " unless params[:rodado_carreta].blank?

    sql = "SELECT F.ID,
									F.TIPO,
    							RC.PLACA AS RODADO_CAVALO,
    							RR.PLACA AS RODADO_CARRETA,
    							PM.NOME AS MOTORISTA_NOME,
    							PP.NOME AS PROPRIETARIO_NOME

                  
            FROM FROTA F
            left JOIN RODADOS RC
           	ON RC.ID = F.RODADO_CV_ID

            left JOIN RODADOS RR
           	ON RR.ID = F.RODADO_CR_ID

            left JOIN PERSONAS PM
           	ON PM.ID = F.MOTORISTA_ID

            left JOIN PERSONAS PP
           	ON PP.ID = F.PROPRIETARIO_ID

            WHERE F.ID > 0 #{id} #{tipo} #{proprietario} #{motorista} #{rodado_cavalo} #{rodado_carreta}
            ORDER BY F.ID DESC"
      Frotum.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end

end

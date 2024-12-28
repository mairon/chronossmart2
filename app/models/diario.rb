class Diario < ActiveRecord::Base
    has_many :diario_debes
    has_many :diario_habers


    def self.busca_acientos(params)

      if params[:seta].to_s == '0'
        if params[:tipo] == "COMPRA"
            processo =  "AND D.TABELA_NOME = 'COMPRA'"
        elsif params[:tipo] == "GASTOS"
            processo =  "AND D.TABELA_NOME = 'COMPRA'"
        elsif params[:tipo] == "VENTAS"
            processo =  "AND D.TABELA_NOME = 'VENTAS'"
        elsif params[:tipo] == "COBROS"
            processo =  "AND D.TABELA_NOME = 'COBROS'"
        elsif params[:tipo] == "PAGOS"
            processo =  "AND D.TABELA_NOME = 'PAGOS'"
        elsif params[:tipo] == "NOTA-REMICION"
            processo =  "AND D.TABELA_NOME = 'NOTA-REMICAO'"
        elsif params[:tipo] == "INGRESOS"
            processo =  "AND D.TABELA_NOME = 'INGRESSOS'"
        elsif params[:tipo] == "EGRESOS"
            processo =  "AND D.TABELA_NOME = 'EGRESSOS'"
        elsif params[:tipo] == "TRANF.CONTAS"
            processo =  "AND D.TABELA_NOME = 'TRANSFERENCIA CONTAS'"
        elsif params[:tipo] == "SUELDO Y JORNALES"
            processo =  "AND D.TABELA_NOME = 'SUELDOS'"
        elsif params[:tipo] == "ADELANTOS"
            processo =  ""
        end
        unidade = params[:unidade]
        cond = " AND D.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'#{processo} " unless params[:inicio].blank?
    else
        cond = " AND D.ID = #{params[:busca]}" unless params[:busca].blank?
    end
    sql = "SELECT D.ID,
                  D.TABELA_ID,
                  D.DATA,
                  D.DOCUMENTO_NUMERO_01,
                  D.DOCUMENTO_NUMERO_02,
                  D.DOCUMENTO_NUMERO,
                  (SELECT SUM(DD.VALOR_GUARANI) FROM DIARIO_DEBES DD WHERE DD.DIARIO_ID = D.ID ) AS DEB_GS,
                  (SELECT SUM(DH.VALOR_GUARANI) FROM DIARIO_HABERS DH WHERE DH.DIARIO_ID = D.ID ) AS HAB_GS,
                  D.DESCRICAO
          FROM DIARIOS D
          WHERE D.UNIDADE_ID = #{unidade} #{cond}
          ORDER BY D.DATA desc, D.ID desc"

    Diario.find_by_sql(sql)
    end

end

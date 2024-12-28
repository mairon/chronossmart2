class PainelClienteController < LoginClienteController
  before_filter :authenticate
	def index

  end

  def laudo_xls_tev
      sql = "SELECT AE.AMOSTRA AS AMOSTRA,
                  AE.PROFUNDIDADE,
                  AE.LOTE,
                  AE.LOCAL_COLETA,
                  AE.DETALHE_AMOSTRA,
                  AE.SOLICITANTE,
                  AE.VARIEDAD,
                  AE.CATEGORIA,
                  AE.PESO,
                  AE.ENVAZE,
                  AE.DATA_EXTRACAO,
                  A.EMPRESA_NOME,
                  A.EMPRESA_ID,
                  A.DATA,
                  C.NOME AS CULTURA,
                  AE.CULTURA_ID,
                  C.CIENTIFICO AS CIENTIFICO
                  FROM ANALIZE_AMOSTRAS AE
                  INNER JOIN ANALIZES A
                  ON A.ID = AE.ANALIZE_ID

                  LEFT JOIN CULTURAS C
                  ON C.ID = AE.CULTURA_ID

            WHERE AE.STATUS = 1 AND A.EMPRESA_ID = ? AND AE.TIPO_ID = ? AND AE.AMOSTRA BETWEEN ? and ?
            ORDER BY AE.AMOSTRA"
    @amostras =  Amostra.find_by_sql([sql,current_cliente.id, params[:tipo].to_i, params[:final].to_i, params[:inicio].to_i])
    respond_to do |format|
      format.xls
    end
    end

  def laudo_xls_gn
      sql = "SELECT AE.AMOSTRA AS AMOSTRA,
                  AE.PROFUNDIDADE,
                  AE.LOTE,
                  AE.LOCAL_COLETA,
                  AE.DETALHE_AMOSTRA,
                  AE.SOLICITANTE,
                  AE.VARIEDAD,
                  AE.CATEGORIA,
                  AE.PESO,
                  AE.ENVAZE,
                  AE.DATA_EXTRACAO,
                  A.EMPRESA_NOME,
                  A.EMPRESA_ID,
                  A.DATA,
                  C.NOME AS CULTURA,
                  AE.CULTURA_ID,
                  C.CIENTIFICO AS CIENTIFICO
                  FROM ANALIZE_AMOSTRAS AE
                  INNER JOIN ANALIZES A
                  ON A.ID = AE.ANALIZE_ID

                  LEFT JOIN CULTURAS C
                  ON C.ID = AE.CULTURA_ID

            WHERE AE.STATUS = 1 AND A.EMPRESA_ID = ? AND AE.TIPO_ID = ? AND AE.AMOSTRA BETWEEN ? and ?
            ORDER BY AE.AMOSTRA"
    @amostras =  Amostra.find_by_sql([sql,current_cliente.id, params[:tipo].to_i, params[:final].to_i, params[:inicio].to_i])
    respond_to do |format|
      format.xls
    end
    end

  def laudo_pdf
    sql = "SELECT AE.AMOSTRA AS AMOSTRA,
                  AE.PROFUNDIDADE,
                  AE.LOTE,
                  AE.LOCAL_COLETA,
                  AE.DETALHE_AMOSTRA,
                  AE.SOLICITANTE,
                  AE.VARIEDAD,
                  AE.CATEGORIA,
                  AE.PESO,
                  AE.ENVAZE,
                  AE.DATA_EXTRACAO,
                  A.EMPRESA_NOME,
                  A.EMPRESA_ID,
                  A.DATA,
                  C.NOME AS CULTURA,
                  AE.CULTURA_ID,
                  C.CIENTIFICO AS CIENTIFICO
                  FROM ANALIZE_AMOSTRAS AE
                  INNER JOIN ANALIZES A
                  ON A.ID = AE.ANALIZE_ID

                  LEFT JOIN CULTURAS C
                  ON C.ID = AE.CULTURA_ID

            WHERE AE.STATUS = 1 AND A.EMPRESA_ID = ? AND AE.TIPO_ID = ? AND AE.AMOSTRA BETWEEN ? and ?
            ORDER BY AE.AMOSTRA"
          @amostras = AmostraEnsaio.find_by_sql([sql,current_cliente.id, params[:tipo].to_i, params[:final].to_i, params[:inicio].to_i])
    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_fechamento_caixa",
                :layout                 => "layer_relatorios",
                :page_height => '11.81in', :page_width => '8.26in',
                :margin => {:top        => '0.20in',
                            :bottom     => '0.30in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta"}
      end
    end
  end
end
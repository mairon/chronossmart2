class AvaliacaoFuncsController < ApplicationController

  def desempenho_anual_refs
    render layout: 'chart'
  end

  def ranked

    if params[:date_year].blank?
      dy = Time.now.strftime("%Y") 
      params[:date_year] = Time.now.strftime("%Y") 
    else 
      dy = params[:date_year] 
    end    

    sql = "SELECT AF.PERSONA_ID,
                  MAX(P.UNIDADE_ID) AS UNIDADE_ID,
                  MAX(P.NOME) AS PERSONA_NOME,
                  MAX(C.NOME) AS CARGO_NOME,
                  (SUM(AFR.NOTA) / 12) AS NOTA
              FROM AVALIACAO_FUNC_REFS AFR

              INNER JOIN AVALIACAO_FUNCS AF
              ON AF.ID = AFR.AVALIACAO_FUNC_ID

              INNER JOIN PERSONAS P
              ON P.ID = AF.PERSONA_ID

              LEFT JOIN CARGOS C
              ON C.ID = P.CARGO_ID

              WHERE P.ESTADO = 0
              AND date_part('YEAR', AF.PERIODO) = '#{dy}'

              GROUP BY 1
              ORDER BY 5 DESC"

    @funcs = AvaliacaoFuncRef.find_by_sql(sql)

    render layout: 'chart'
  end

  def update_individual
    AvaliacaoFuncRef.update(params[:avaliacao_func_refs].keys, params[:avaliacao_func_refs].values)
    redirect_to avaliacao_funcs_url
    flash[:notice] = "Preciso Actulizados!"
  end

  def index
  end

  def busca
    @avaliacao_funcs = AvaliacaoFunc.where("date_part('month', PERIODO) = '#{params[:mes]}'  AND  date_part('year', PERIODO) = '#{params[:ano]}'").order('id desc')
    render layout: false


    if params[:tipo] == '1'
      respond_to do |format|
      format.html do
          render  :pdf                    => "busca",
                  :layout                 => "layer_relatorios",
                  :margin => {:top        => '0.95in',
                              :bottom     => '0.25in',
                              :left       => '0.10in',
                              :right      => '0.10in'},
                  :header => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                              :font_size  => 7,
                              :spacing    => 20},
                  :footer => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                              :font_size  => 7,
                              :right      => "Pagina [page] de [toPage]",
                              :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
        end
      end
    end

  end

  def show
    @avaliacao_func = AvaliacaoFunc.find(params[:id])
    render layout: 'chart'
  end

  # GET /avaliacao_funcs/new
  # GET /avaliacao_funcs/new.json
  def new
    @avaliacao_func = AvaliacaoFunc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @avaliacao_func }
    end
  end

  # GET /avaliacao_funcs/1/edit
  def edit
    @avaliacao_func = AvaliacaoFunc.find(params[:id])
  end

  # POST /avaliacao_funcs
  # POST /avaliacao_funcs.json
  def create
    @avaliacao_func = AvaliacaoFunc.new(params[:avaliacao_func])

    respond_to do |format|
      if @avaliacao_func.save
        format.html { redirect_to @avaliacao_func, notice: 'Avaliacao func was successfully created.' }
        format.json { render json: @avaliacao_func, status: :created, location: @avaliacao_func }
      else
        format.html { render action: "new" }
        format.json { render json: @avaliacao_func.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /avaliacao_funcs/1
  # PUT /avaliacao_funcs/1.json
  def update
    @avaliacao_func = AvaliacaoFunc.find(params[:id])

    respond_to do |format|
      if @avaliacao_func.update_attributes(params[:avaliacao_func])
        format.html { redirect_to @avaliacao_func, notice: 'Avaliacao func was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @avaliacao_func.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /avaliacao_funcs/1
  # DELETE /avaliacao_funcs/1.json
  def destroy
    @avaliacao_func = AvaliacaoFunc.find(params[:id])
    @avaliacao_func.destroy

    respond_to do |format|
      format.html { redirect_to avaliacao_funcs_url }
      format.json { head :no_content }
    end
  end
end

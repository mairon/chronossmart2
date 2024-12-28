class TarefasController < ApplicationController

  def busca_tarefas
    dt = "AND T.DIA_INICIO >= '#{Time.now.strftime("%Y-%m-%d")}'" if params[:lancamento] != '1'

    sql = " SELECT T.ID,
                    T.PERSONA_NOME,
                    T.DIA_INICIO,
                    T.VENDEDOR_ID,
                    T.DESCRICAO,
                    T.DIA_FINAL,
                    VD.NOME AS VENDEDOR_NOME,
                    VD.COLOR_TAG
            FROM  TAREFAS T
            LEFT JOIN PERSONAS VD
            ON VD.ID = T.VENDEDOR_ID
     WHERE T.PERSONA_NOME ILIKE '%#{params[:busca]}%' #{dt}
     ORDER BY T.DIA_INICIO"

    @tarefas = Tarefa.find_by_sql(sql)

    render layout: false
  end
  def index
     usuario = "AND T.VENDEDOR_ID = #{params[:vendedor_id]}" unless params[:vendedor_id].blank?

      sql ="SELECT T.ID,
                   T.VENDEDOR_ID,
                   T.PERSONA_ID,
                   T.PERSONA_NOME,
                   T.dia_INICIO,
                   T.dia_FINAL,
                   T.DESCRICAO,
                   VD.NOME AS VENDEDOR_NOME,
                   VD.COLOR_TAG
              FROM TAREFAS T

               LEFT JOIN PERSONAS VD
               ON VD.ID = T.VENDEDOR_ID

            WHERE T.dia_inicio >= '2023-06-01' #{usuario}
            ORDER BY 5"
      @tarefas = Tarefa.find_by_sql(sql)


sql_hoy ="SELECT T.ID AS ID,
                   T.VENDEDOR_ID,
                   T.PERSONA_ID,
                   T.PERSONA_NOME,
                   T.dia_INICIO,
                   T.dia_FINAL,
                   T.DESCRICAO,
                   VD.NOME AS VENDEDOR_NOME,
                   VD.COLOR_TAG
              FROM TAREFAS T

               LEFT JOIN PERSONAS VD
               ON VD.ID = T.VENDEDOR_ID

            WHERE T.dia_inicio::date = '#{Time.now.strftime("%Y-%m-%d")}' #{usuario}
            ORDER BY 5"
      @tarefas_hoy = Tarefa.find_by_sql(sql_hoy)

    render layout: 'chart'
  end

  # GET /tarefas/1
  # GET /tarefas/1.json
  def show
    @tarefa = Tarefa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tarefa }
    end
  end

  # GET /tarefas/new
  # GET /tarefas/new.json
  def new
    @tarefa = Tarefa.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tarefa }
    end
  end

  # GET /tarefas/1/edit
  def edit
    @tarefa = Tarefa.find(params[:id])
    render layout: 'chart'
  end

  # POST /tarefas
  # POST /tarefas.json
  def create
    @tarefa = Tarefa.new(params[:tarefa])

    respond_to do |format|
      if @tarefa.save
        
        if @tarefa.origem == "CRM"
          format.html { redirect_to crm_negocio_path(@tarefa.negocio_id) }
        else  
          format.html { redirect_to tarefas_path(vendedor_id: @tarefa.vendedor_id, data: @tarefa.dia_inicio.strftime("%Y-%m-%d") ) }
        end
        
      else
        format.html { render action: "new" }
      end
    end
  end
  # PUT /tarefas/1
  # PUT /tarefas/1.json
  def update
    @tarefa = Tarefa.find(params[:id])

    respond_to do |format|
      if @tarefa.update_attributes(params[:tarefa])
        format.html { redirect_to tarefas_path(vendedor_id: @tarefa.vendedor_id, data: @tarefa.dia_inicio.strftime("%Y-%m-%d") ) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tarefa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tarefas/1
  # DELETE /tarefas/1.json
  def destroy
    @tarefa = Tarefa.find(params[:id])
    @tarefa.destroy

    respond_to do |format|
        if @tarefa.origem == "CRM"
          format.html { redirect_to crm_negocio_path(@tarefa.negocio_id) }
        else  
          format.html { redirect_to tarefas_url }
        end

      format.json { head :no_content }
    end
  end
end

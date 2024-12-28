class Crm::PipelinesController < Crm::CrmController

  def index
    @pipelines = Pipeline.all
    render layout: 'chart'
  end

  def configs
    @pipeline = Pipeline.find(params[:id])

    render layout: 'chart'
  end


  def show

    @pipeline = Pipeline.find(params[:id])
    @usuario_pipe =  PipelineUsuario.where(pipeline_id: @pipeline.id, usuario_id: current_user.id).last

    if @usuario_pipe.nil?
      redirect_to crm_pipelines_url, notice: "Usuario no Habilitado!" and return
    else
      @usuario_pipe
      @negocio = Negocio.new
      @steps = Etapa.where(pipeline_id: @pipeline.id).order(:ordem)
    end

    render layout: 'crm'
  end

  def new
    @pipeline = Pipeline.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pipeline }
    end
  end

  def edit
    @pipeline = Pipeline.find(params[:id])
  end

  # POST /pipelines
  # POST /pipelines.json
  def create
    @pipeline = Pipeline.new(params[:pipeline])

    respond_to do |format|
      if @pipeline.save
        format.html { redirect_to configs_crm_pipeline_path(@pipeline) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /pipelines/1
  # PUT /pipelines/1.json
  def update
    @pipeline = Pipeline.find(params[:id])

    respond_to do |format|
      if @pipeline.update_attributes(params[:pipeline])
        format.html { redirect_to configs_crm_pipeline_path(@pipeline) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /pipelines/1
  # DELETE /pipelines/1.json
  def destroy
    @pipeline = Pipeline.find(params[:id])
    @pipeline.destroy

    respond_to do |format|
      format.html { redirect_to crm_pipelines_url }
      format.json { head :no_content }
    end
  end
end

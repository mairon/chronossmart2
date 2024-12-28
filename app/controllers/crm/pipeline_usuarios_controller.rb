class Crm::PipelineUsuariosController  < Crm::CrmController
  # GET /pipeline_usuarios
  # GET /pipeline_usuarios.json
  def index
    @pipeline_usuarios = PipelineUsuario.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pipeline_usuarios }
    end
  end

  # GET /pipeline_usuarios/1
  # GET /pipeline_usuarios/1.json
  def show
    @pipeline_usuario = PipelineUsuario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pipeline_usuario }
    end
  end

  # GET /pipeline_usuarios/new
  # GET /pipeline_usuarios/new.json
  def new
    @pipeline_usuario = PipelineUsuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pipeline_usuario }
    end
  end

  # GET /pipeline_usuarios/1/edit
  def edit
    @pipeline_usuario = PipelineUsuario.find(params[:id])
  end

  # POST /pipeline_usuarios
  # POST /pipeline_usuarios.json
  def create
    @pipeline_usuario = PipelineUsuario.new(params[:pipeline_usuario])

    respond_to do |format|
      if @pipeline_usuario.save
        format.html { redirect_to configs_crm_pipeline_path(@pipeline_usuario.pipeline_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /pipeline_usuarios/1
  # PUT /pipeline_usuarios/1.json
  def update
    @pipeline_usuario = PipelineUsuario.find(params[:id])

    respond_to do |format|
      if @pipeline_usuario.update_attributes(params[:pipeline_usuario])
        format.html { redirect_to configs_crm_pipeline_path(@pipeline_usuario.pipeline_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /pipeline_usuarios/1
  # DELETE /pipeline_usuarios/1.json
  def destroy
    @pipeline_usuario = PipelineUsuario.find(params[:id])
    @pipeline_usuario.destroy

    respond_to do |format|
      format.html { redirect_to configs_crm_pipeline_path(@pipeline_usuario.pipeline_id) }
    end
  end
end

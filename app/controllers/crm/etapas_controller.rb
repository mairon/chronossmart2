class Crm::EtapasController  < Crm::CrmController

  def update_order_etapas
    ordem_etapas = params[:ids].to_json


    JSON.parse(ordem_etapas).each do |item|
      Etapa.find(item[1]["id"]).update_column(:ordem, item[0])
    end

    render json: { data: 'OK', status: 200 }    
  end

  def index
    @etapas = Etapa.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @etapas }
    end
  end

  # GET /etapas/1
  # GET /etapas/1.json
  def show
    @etapa = Etapa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etapa }
    end
  end

  # GET /etapas/new
  # GET /etapas/new.json
  def new
    @etapa = Etapa.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @etapa }
    end
  end

  # GET /etapas/1/edit
  def edit
    @etapa = Etapa.find(params[:id])
  end

  # POST /etapas
  # POST /etapas.json
  def create
    @etapa = Etapa.new(params[:etapa])

    respond_to do |format|
      if @etapa.save
        format.html { redirect_to configs_crm_pipeline_path(@etapa.pipeline_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /etapas/1
  # PUT /etapas/1.json
  def update
    @etapa = Etapa.find(params[:id])

    respond_to do |format|
      if @etapa.update_attributes(params[:etapa])
        format.html { redirect_to configs_crm_pipeline_path(@etapa.pipeline_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /etapas/1
  # DELETE /etapas/1.json
  def destroy
    @etapa = Etapa.find(params[:id])
    @etapa.destroy

    respond_to do |format|
      format.html { redirect_to configs_crm_pipeline_path(@etapa.pipeline_id) }
    end
  end
end

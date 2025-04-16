class Tms::FrotaController < Tms::TmsController

  def busca_frota
    @frota = Frotum.busca_frota(params)
    render :layout => false
  end

  def index
  end

  # GET /frota/1
  # GET /frota/1.json
  def show
    @frotum = Frotum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @frotum }
    end
  end

  # GET /frota/new
  # GET /frota/new.json
  def new
    @frotum = Frotum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @frotum }
    end
  end

  # GET /frota/1/edit
  def edit
    @frotum = Frotum.find(params[:id])
  end

  # POST /frota
  # POST /frota.json
  def create
    @frotum = Frotum.new(params[:frotum])

    respond_to do |format|
      if @frotum.save
        format.html { redirect_to tms_frota_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /frota/1
  # PUT /frota/1.json
  def update
    @frotum = Frotum.find(params[:id])

    respond_to do |format|
      if @frotum.update_attributes(params[:frotum])
        format.html { redirect_to tms_frota_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /frota/1
  # DELETE /frota/1.json
  def destroy
    @frotum = Frotum.find(params[:id])
    @frotum.destroy

    respond_to do |format|
      format.html { redirect_to tms_frota_url }
      format.json { head :no_content }
    end
  end
end

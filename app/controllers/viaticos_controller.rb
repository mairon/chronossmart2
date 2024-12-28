class ViaticosController < ApplicationController


  def comprovante
    @viatico = Viatico.find(params[:id])

    render :layout => false 
  end


  def index
    @viatico = Viatico.new
  end

  def busca_viatico
    params[:unidade] = current_unidade.id
    params[:usuario_id] = current_user.id
    @viaticos = Viatico.filtro_busca_viatico(params)
    render :layout => false
  end

  def show
    @viatico = Viatico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @viatico }
    end
  end

  # GET /viaticos/new
  # GET /viaticos/new.json
  def new
    @viatico = Viatico.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @viatico }
    end
  end

  # GET /viaticos/1/edit
  def edit
    @viatico = Viatico.find(params[:id])
  end

  # POST /viaticos
  # POST /viaticos.json
  def create
    @viatico = Viatico.new(params[:viatico])
    @viatico.unidade_id = current_unidade.id

    respond_to do |format|
      if @viatico.save
        format.html { redirect_to viaticos_url }
        format.json { render json: @viatico, status: :created, location: @viatico }
      else
        format.html { render action: "new" }
        format.json { render json: @viatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /viaticos/1
  # PUT /viaticos/1.json
  def update
    @viatico = Viatico.find(params[:id])

    respond_to do |format|
      if @viatico.update_attributes(params[:viatico])
        format.html { redirect_to viaticos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @viatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticos/1
  # DELETE /viaticos/1.json
  def destroy
    @viatico = Viatico.find(params[:id])
    @viatico.destroy

    respond_to do |format|
      format.html { redirect_to viaticos_url }
      format.json { head :no_content }
    end
  end
end

class RegiaosController < ApplicationController
  # GET /regiaos
  # GET /regiaos.json
  def index
    @regiaos = Regiao.order("paise_id, estado_id, nome")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @regiaos }
    end
  end

  # GET /regiaos/1
  # GET /regiaos/1.json
  def show
    @regiao = Regiao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @regiao }
    end
  end

  # GET /regiaos/new
  # GET /regiaos/new.json
  def new
    @regiao = Regiao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @regiao }
    end
  end

  # GET /regiaos/1/edit
  def edit
    @regiao = Regiao.find(params[:id])
  end

  # POST /regiaos
  # POST /regiaos.json
  def create
    @regiao = Regiao.new(params[:regiao])

    respond_to do |format|
      if @regiao.save
        format.html { redirect_to regiaos_url }
        format.json { render json: @regiao, status: :created, location: @regiao }
      else
        format.html { render action: "new" }
        format.json { render json: @regiao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /regiaos/1
  # PUT /regiaos/1.json
  def update
    @regiao = Regiao.find(params[:id])

    respond_to do |format|
      if @regiao.update_attributes(params[:regiao])
        format.html { redirect_to regiaos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @regiao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regiaos/1
  # DELETE /regiaos/1.json
  def destroy
    @regiao = Regiao.find(params[:id])
    @regiao.destroy

    respond_to do |format|
      format.html { redirect_to regiaos_url }
      format.json { head :no_content }
    end
  end

  def dynamic_estados
    @estados = Estado.where("paise_id = #{params[:id]}").select('nome,id').order('nome')
    respond_to do |format|
      format.js
    end
  end

end

class BrigadasController < ApplicationController
  # GET /brigadas
  # GET /brigadas.json
  def index
    @brigadas = Brigada.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brigadas }
    end
  end

  # GET /brigadas/1
  # GET /brigadas/1.json
  def show
    @brigada = Brigada.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brigada }
    end
  end

  # GET /brigadas/new
  # GET /brigadas/new.json
  def new
    @brigada = Brigada.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brigada }
    end
  end

  # GET /brigadas/1/edit
  def edit
    @brigada = Brigada.find(params[:id])
  end

  # POST /brigadas
  # POST /brigadas.json
  def create
    @brigada = Brigada.new(params[:brigada])

    respond_to do |format|
      if @brigada.save
        format.html { redirect_to brigadas_url }
      else
        format.html { render action: "new" }
        format.json { render json: @brigada.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brigadas/1
  # PUT /brigadas/1.json
  def update
    @brigada = Brigada.find(params[:id])

    respond_to do |format|
      if @brigada.update_attributes(params[:brigada])
        format.html { redirect_to brigadas_url }
      else
        format.html { render action: "edit" }
        format.json { render json: @brigada.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brigadas/1
  # DELETE /brigadas/1.json
  def destroy
    @brigada = Brigada.find(params[:id])
    @brigada.destroy

    respond_to do |format|
      format.html { redirect_to brigadas_url }
    end
  end
end

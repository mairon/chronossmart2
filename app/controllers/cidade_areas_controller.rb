class CidadeAreasController < ApplicationController
  # GET /cidade_areas
  # GET /cidade_areas.json
  def index
    @cidade_areas = CidadeArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cidade_areas }
    end
  end

  # GET /cidade_areas/1
  # GET /cidade_areas/1.json
  def show
    @cidade_area = CidadeArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cidade_area }
    end
  end

  # GET /cidade_areas/new
  # GET /cidade_areas/new.json
  def new
    @cidade_area = CidadeArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cidade_area }
    end
  end

  # GET /cidade_areas/1/edit
  def edit
    @cidade_area = CidadeArea.find(params[:id])
  end

  # POST /cidade_areas
  # POST /cidade_areas.json
  def create
    @cidade_area = CidadeArea.new(params[:cidade_area])

    respond_to do |format|
      if @cidade_area.save
        format.html { redirect_to "/cidades/#{@cidade_area.cidade_id}"}
      else
        format.html { render action: "new" }
        format.json { render json: @cidade_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cidade_areas/1
  # PUT /cidade_areas/1.json
  def update
    @cidade_area = CidadeArea.find(params[:id])

    respond_to do |format|
      if @cidade_area.update_attributes(params[:cidade_area])
        format.html { redirect_to "/cidades/#{@cidade_area.cidade_id}"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cidade_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cidade_areas/1
  # DELETE /cidade_areas/1.json
  def destroy
    @cidade_area = CidadeArea.find(params[:id])
    @cidade_area.destroy

    respond_to do |format|
      format.html { redirect_to "cidades/#{@cidade_area.cidade_id}"}
      format.json { head :no_content }
    end
  end
end

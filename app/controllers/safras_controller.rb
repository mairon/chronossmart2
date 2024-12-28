class SafrasController < ApplicationController
  # GET /safras
  # GET /safras.json
  def index
    @safras = Safra.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safras }
    end
  end

  # GET /safras/1
  # GET /safras/1.json
  def show
    @safra = Safra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra }
    end
  end

  # GET /safras/new
  # GET /safras/new.json
  def new
    @safra = Safra.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra }
    end
  end

  # GET /safras/1/edit
  def edit
    @safra = Safra.find(params[:id])
  end

  # POST /safras
  # POST /safras.json
  def create
    @safra = Safra.new(params[:safra])

    respond_to do |format|
      if @safra.save
        format.html { redirect_to @safra, notice: 'Safra was successfully created.' }
        format.json { render json: @safra, status: :created, location: @safra }
      else
        format.html { render action: "new" }
        format.json { render json: @safra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safras/1
  # PUT /safras/1.json
  def update
    @safra = Safra.find(params[:id])

    respond_to do |format|
      if @safra.update_attributes(params[:safra])
        format.html { redirect_to @safra, notice: 'Safra was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safras/1
  # DELETE /safras/1.json
  def destroy
    @safra = Safra.find(params[:id])
    @safra.destroy

    respond_to do |format|
      format.html { redirect_to safras_url }
      format.json { head :no_content }
    end
  end
end

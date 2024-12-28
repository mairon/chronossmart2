class ComitesController < ApplicationController
  # GET /comites
  # GET /comites.json
  def index
    @comites = Comite.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comites }
    end
  end

  # GET /comites/1
  # GET /comites/1.json
  def show
    @comite = Comite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comite }
    end
  end

  # GET /comites/new
  # GET /comites/new.json
  def new
    @comite = Comite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comite }
    end
  end

  # GET /comites/1/edit
  def edit
    @comite = Comite.find(params[:id])
  end

  # POST /comites
  # POST /comites.json
  def create
    @comite = Comite.new(params[:comite])

    respond_to do |format|
      if @comite.save
        format.html { redirect_to comites_url }
        format.json { render json: @comite, status: :created, location: @comite }
      else
        format.html { render action: "new" }
        format.json { render json: @comite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comites/1
  # PUT /comites/1.json
  def update
    @comite = Comite.find(params[:id])

    respond_to do |format|
      if @comite.update_attributes(params[:comite])
        format.html { redirect_to comites_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comites/1
  # DELETE /comites/1.json
  def destroy
    @comite = Comite.find(params[:id])
    @comite.destroy

    respond_to do |format|
      format.html { redirect_to comites_url }
      format.json { head :no_content }
    end
  end
end

class NoftAppsController < ApplicationController
  # GET /noft_apps
  # GET /noft_apps.json
  def index
    @noft_apps = NoftApp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @noft_apps }
    end
  end

  # GET /noft_apps/1
  # GET /noft_apps/1.json
  def show
    @noft_app = NoftApp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @noft_app }
    end
  end

  # GET /noft_apps/new
  # GET /noft_apps/new.json
  def new
    @noft_app = NoftApp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @noft_app }
    end
  end

  # GET /noft_apps/1/edit
  def edit
    @noft_app = NoftApp.find(params[:id])
  end

  # POST /noft_apps
  # POST /noft_apps.json
  def create
    @noft_app = NoftApp.new(params[:noft_app])

    respond_to do |format|
      if @noft_app.save
        format.html { redirect_to @noft_app, notice: 'Noft app was successfully created.' }
        format.json { render json: @noft_app, status: :created, location: @noft_app }
      else
        format.html { render action: "new" }
        format.json { render json: @noft_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /noft_apps/1
  # PUT /noft_apps/1.json
  def update
    @noft_app = NoftApp.find(params[:id])

    respond_to do |format|
      if @noft_app.update_attributes(params[:noft_app])
        format.html { redirect_to @noft_app, notice: 'Noft app was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @noft_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /noft_apps/1
  # DELETE /noft_apps/1.json
  def destroy
    @noft_app = NoftApp.find(params[:id])
    @noft_app.destroy

    respond_to do |format|
      format.html { redirect_to noft_apps_url }
      format.json { head :no_content }
    end
  end
end

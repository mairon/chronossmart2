class ConfigContabilsController < ApplicationController
  # GET /config_contabils
  # GET /config_contabils.json
  def index
    @config_contabils = ConfigContabil.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @config_contabils }
    end
  end

  # GET /config_contabils/1
  # GET /config_contabils/1.json
  def show
    @config_contabil = ConfigContabil.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @config_contabil }
    end
  end

  # GET /config_contabils/new
  # GET /config_contabils/new.json
  def new
    @config_contabil = ConfigContabil.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @config_contabil }
    end
  end

  # GET /config_contabils/1/edit
  def edit
    @config_contabil = ConfigContabil.find(params[:id])
  end

  # POST /config_contabils
  # POST /config_contabils.json
  def create
    @config_contabil = ConfigContabil.new(params[:config_contabil])

    respond_to do |format|
      if @config_contabil.save
        format.html { redirect_to config_contabils_url }
        format.json { render json: @config_contabil, status: :created, location: @config_contabil }
      else
        format.html { render action: "new" }
        format.json { render json: @config_contabil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /config_contabils/1
  # PUT /config_contabils/1.json
  def update
    @config_contabil = ConfigContabil.find(params[:id])

    respond_to do |format|
      if @config_contabil.update_attributes(params[:config_contabil])
        format.html { redirect_to config_contabils_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @config_contabil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /config_contabils/1
  # DELETE /config_contabils/1.json
  def destroy
    @config_contabil = ConfigContabil.find(params[:id])
    @config_contabil.destroy

    respond_to do |format|
      format.html { redirect_to config_contabils_url }
      format.json { head :no_content }
    end
  end
end

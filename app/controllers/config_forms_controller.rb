class ConfigFormsController < ApplicationController
  # GET /config_forms
  # GET /config_forms.json
  def index
    @config_forms = ConfigForm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @config_forms }
    end
  end

  # GET /config_forms/1
  # GET /config_forms/1.json
  def show
    @config_form = ConfigForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @config_form }
    end
  end

  # GET /config_forms/new
  # GET /config_forms/new.json
  def new
    @config_form = ConfigForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @config_form }
    end
  end

  # GET /config_forms/1/edit
  def edit
    @config_form = ConfigForm.find(params[:id])
  end

  # POST /config_forms
  # POST /config_forms.json
  def create
    @config_form = ConfigForm.new(params[:config_form])

    respond_to do |format|
      if @config_form.save
        format.html { redirect_to config_forms_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /config_forms/1
  # PUT /config_forms/1.json
  def update
    @config_form = ConfigForm.find(params[:id])

    respond_to do |format|
      if @config_form.update_attributes(params[:config_form])
        format.html { redirect_to config_forms_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /config_forms/1
  # DELETE /config_forms/1.json
  def destroy
    @config_form = ConfigForm.find(params[:id])
    @config_form.destroy

    respond_to do |format|
      format.html { redirect_to config_forms_url }
    end
  end
end

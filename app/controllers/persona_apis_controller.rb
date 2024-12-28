class PersonaApisController < ApplicationController
  # GET /persona_apis
  # GET /persona_apis.json
  def index
    @persona_apis = PersonaApi.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_apis }
    end
  end

  # GET /persona_apis/1
  # GET /persona_apis/1.json
  def show
    @persona_api = PersonaApi.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_api }
    end
  end

  # GET /persona_apis/new
  # GET /persona_apis/new.json
  def new
    @persona_api = PersonaApi.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_api }
    end
  end

  # GET /persona_apis/1/edit
  def edit
    @persona_api = PersonaApi.find(params[:id])
  end

  # POST /persona_apis
  # POST /persona_apis.json
  def create
    @persona_api = PersonaApi.new(params[:persona_api])

    respond_to do |format|
      if @persona_api.save
        format.html { redirect_to @persona_api, notice: 'Persona api was successfully created.' }
        format.json { render json: @persona_api, status: :created, location: @persona_api }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_api.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_apis/1
  # PUT /persona_apis/1.json
  def update
    @persona_api = PersonaApi.find(params[:id])

    respond_to do |format|
      if @persona_api.update_attributes(params[:persona_api])
        format.html { redirect_to @persona_api, notice: 'Persona api was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_api.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_apis/1
  # DELETE /persona_apis/1.json
  def destroy
    @persona_api = PersonaApi.find(params[:id])
    @persona_api.destroy

    respond_to do |format|
      format.html { redirect_to persona_apis_url }
      format.json { head :no_content }
    end
  end
end

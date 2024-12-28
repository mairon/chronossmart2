class PersonaChofersController < ApplicationController
  # GET /persona_chofers
  # GET /persona_chofers.json
  def index
    @persona_chofers = PersonaChofer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_chofers }
    end
  end

  # GET /persona_chofers/1
  # GET /persona_chofers/1.json
  def show
    @persona_chofer = PersonaChofer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_chofer }
    end
  end

  # GET /persona_chofers/new
  # GET /persona_chofers/new.json
  def new
    @persona_chofer = PersonaChofer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_chofer }
    end
  end

  # GET /persona_chofers/1/edit
  def edit
    @persona_chofer = PersonaChofer.find(params[:id])
  end

  # POST /persona_chofers
  # POST /persona_chofers.json
  def create
    @persona_chofer = PersonaChofer.new(params[:persona_chofer])

    respond_to do |format|
      if @persona_chofer.save
        format.html { redirect_to "/personas/#{@persona_chofer.persona_id}" }
        
      else
        format.html { render action: "new" }
        format.json { render json: @persona_chofer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_chofers/1
  # PUT /persona_chofers/1.json
  def update
    @persona_chofer = PersonaChofer.find(params[:id])

    respond_to do |format|
      if @persona_chofer.update_attributes(params[:persona_chofer])
        format.html { redirect_to "/personas/#{@persona_chofer.persona_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_chofer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_chofers/1
  # DELETE /persona_chofers/1.json
  def destroy
    @persona_chofer = PersonaChofer.find(params[:id])
    @persona_chofer.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_chofer.persona_id}" }
      format.json { head :no_content }
    end
  end
end

class PersonaContatosController < ApplicationController
  # GET /persona_contatos
  # GET /persona_contatos.json
  def index
    @persona_contatos = PersonaContato.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_contatos }
    end
  end

  # GET /persona_contatos/1
  # GET /persona_contatos/1.json
  def show
    @persona_contato = PersonaContato.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_contato }
    end
  end

  # GET /persona_contatos/new
  # GET /persona_contatos/new.json
  def new
    @persona_contato = PersonaContato.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_contato }
    end
  end

  # GET /persona_contatos/1/edit
  def edit
    @persona_contato = PersonaContato.find(params[:id])
  end

  # POST /persona_contatos
  # POST /persona_contatos.json
  def create
    @persona_contato = PersonaContato.new(params[:persona_contato])

    respond_to do |format|
      if @persona_contato.save
        format.html { redirect_to "/personas/#{@persona_contato.persona_id}" }
        format.json { render json: @persona_contato, status: :created, location: @persona_contato }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_contato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_contatos/1
  # PUT /persona_contatos/1.json
  def update
    @persona_contato = PersonaContato.find(params[:id])

    respond_to do |format|
      if @persona_contato.update_attributes(params[:persona_contato])
        format.html { redirect_to "/personas/#{@persona_contato.persona_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_contato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_contatos/1
  # DELETE /persona_contatos/1.json
  def destroy
    @persona_contato = PersonaContato.find(params[:id])
    @persona_contato.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_contato.persona_id}" }
      format.json { head :no_content }
    end
  end
end

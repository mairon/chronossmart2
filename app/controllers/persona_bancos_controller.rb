class PersonaBancosController < ApplicationController
  # GET /persona_bancos
  # GET /persona_bancos.json
  def index
    @persona_bancos = PersonaBanco.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_bancos }
    end
  end

  # GET /persona_bancos/1
  # GET /persona_bancos/1.json
  def show
    @persona_banco = PersonaBanco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_banco }
    end
  end

  # GET /persona_bancos/new
  # GET /persona_bancos/new.json
  def new
    @persona_banco = PersonaBanco.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_banco }
    end
  end

  # GET /persona_bancos/1/edit
  def edit
    @persona_banco = PersonaBanco.find(params[:id])
  end

  # POST /persona_bancos
  # POST /persona_bancos.json
  def create
    @persona_banco = PersonaBanco.new(params[:persona_banco])

    respond_to do |format|
      if @persona_banco.save
        format.html { redirect_to decla_jurada_persona_path(@persona_banco.persona_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /persona_bancos/1
  # PUT /persona_bancos/1.json
  def update
    @persona_banco = PersonaBanco.find(params[:id])

    respond_to do |format|
      if @persona_banco.update_attributes(params[:persona_banco])
        format.html { redirect_to decla_jurada_persona_path(@persona_banco.persona_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /persona_bancos/1
  # DELETE /persona_bancos/1.json
  def destroy
    @persona_banco = PersonaBanco.find(params[:id])
    @persona_banco.destroy

    respond_to do |format|
      format.html { redirect_to decla_jurada_persona_path(@persona_banco.persona_id) }
    end
  end
end

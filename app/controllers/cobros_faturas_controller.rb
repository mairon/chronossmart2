class CobrosFaturasController < ApplicationController
  # GET /cobros_faturas
  # GET /cobros_faturas.json
  def index
    @cobros_faturas = CobrosFatura.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cobros_faturas }
    end
  end

  # GET /cobros_faturas/1
  # GET /cobros_faturas/1.json
  def show
    @cobros_fatura = CobrosFatura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cobros_fatura }
    end
  end

  # GET /cobros_faturas/new
  # GET /cobros_faturas/new.json
  def new
    @cobros_fatura = CobrosFatura.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cobros_fatura }
    end
  end

  # GET /cobros_faturas/1/edit
  def edit
    @cobros_fatura = CobrosFatura.find(params[:id])
  end

  # POST /cobros_faturas
  # POST /cobros_faturas.json
  def create
    @cobros_fatura = CobrosFatura.new(params[:cobros_fatura])

    respond_to do |format|
      if @cobros_fatura.save
        format.html { redirect_to @cobros_fatura, notice: 'Cobros fatura was successfully created.' }
        format.json { render json: @cobros_fatura, status: :created, location: @cobros_fatura }
      else
        format.html { render action: "new" }
        format.json { render json: @cobros_fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cobros_faturas/1
  # PUT /cobros_faturas/1.json
  def update
    @cobros_fatura = CobrosFatura.find(params[:id])

    respond_to do |format|
      if @cobros_fatura.update_attributes(params[:cobros_fatura])
        format.html { redirect_to @cobros_fatura, notice: 'Cobros fatura was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cobros_fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cobros_faturas/1
  # DELETE /cobros_faturas/1.json
  def destroy
    @cobros_fatura = CobrosFatura.find(params[:id])
    @cobros_fatura.destroy

    respond_to do |format|
      format.html { redirect_to cobros_faturas_url }
      format.json { head :no_content }
    end
  end
end

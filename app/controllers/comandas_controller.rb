class ComandasController < ApplicationController
  # GET /comandas
  # GET /comandas.json
  def index
    @comandas = Comanda.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comandas }
    end
  end

  # GET /comandas/1
  # GET /comandas/1.json
  def show
    @comanda = Comanda.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comanda }
    end
  end

  # GET /comandas/new
  # GET /comandas/new.json
  def new
    @comanda = Comanda.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comanda }
    end
  end

  # GET /comandas/1/edit
  def edit
    @comanda = Comanda.find(params[:id])
  end

  # POST /comandas
  # POST /comandas.json
  def create
    @comanda = Comanda.new(params[:comanda])

    respond_to do |format|
      if @comanda.save
        format.html { redirect_to @comanda, notice: 'Comanda was successfully created.' }
        format.json { render json: @comanda, status: :created, location: @comanda }
      else
        format.html { render action: "new" }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comandas/1
  # PUT /comandas/1.json
  def update
    @comanda = Comanda.find(params[:id])

    respond_to do |format|
      if @comanda.update_attributes(params[:comanda])
        format.html { redirect_to @comanda, notice: 'Comanda was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comandas/1
  # DELETE /comandas/1.json
  def destroy
    @comanda = Comanda.find(params[:id])
    @comanda.destroy

    respond_to do |format|
      format.html { redirect_to comandas_url }
      format.json { head :no_content }
    end
  end
end

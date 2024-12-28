class ParcelasController < ApplicationController
  # GET /parcelas
  # GET /parcelas.json
  def index
    @parcelas = Parcela.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parcelas }
    end
  end

  # GET /parcelas/1
  # GET /parcelas/1.json
  def show
    @parcela = Parcela.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parcela }
    end
  end

  # GET /parcelas/new
  # GET /parcelas/new.json
  def new
    @parcela = Parcela.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parcela }
    end
  end

  # GET /parcelas/1/edit
  def edit
    @parcela = Parcela.find(params[:id])
  end

  # POST /parcelas
  # POST /parcelas.json
  def create
    @parcela = Parcela.new(params[:parcela])

    respond_to do |format|
      if @parcela.save
        format.html { redirect_to @parcela, notice: 'Parcela was successfully created.' }
        format.json { render json: @parcela, status: :created, location: @parcela }
      else
        format.html { render action: "new" }
        format.json { render json: @parcela.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parcelas/1
  # PUT /parcelas/1.json
  def update
    @parcela = Parcela.find(params[:id])

    respond_to do |format|
      if @parcela.update_attributes(params[:parcela])
        format.html { redirect_to @parcela, notice: 'Parcela was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @parcela.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcelas/1
  # DELETE /parcelas/1.json
  def destroy
    @parcela = Parcela.find(params[:id])
    @parcela.destroy

    respond_to do |format|
      format.html { redirect_to parcelas_url }
      format.json { head :no_content }
    end
  end
end

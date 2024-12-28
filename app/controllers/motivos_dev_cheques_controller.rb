class MotivosDevChequesController < ApplicationController
  # GET /motivos_dev_cheques
  # GET /motivos_dev_cheques.json
  def index
    @motivos_dev_cheques = MotivosDevCheque.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @motivos_dev_cheques }
    end
  end

  # GET /motivos_dev_cheques/1
  # GET /motivos_dev_cheques/1.json
  def show
    @motivos_dev_cheque = MotivosDevCheque.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @motivos_dev_cheque }
    end
  end

  # GET /motivos_dev_cheques/new
  # GET /motivos_dev_cheques/new.json
  def new
    @motivos_dev_cheque = MotivosDevCheque.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @motivos_dev_cheque }
    end
  end

  # GET /motivos_dev_cheques/1/edit
  def edit
    @motivos_dev_cheque = MotivosDevCheque.find(params[:id])
  end

  # POST /motivos_dev_cheques
  # POST /motivos_dev_cheques.json
  def create
    @motivos_dev_cheque = MotivosDevCheque.new(params[:motivos_dev_cheque])

    respond_to do |format|
      if @motivos_dev_cheque.save
        format.html { redirect_to @motivos_dev_cheque, notice: 'Motivos dev cheque was successfully created.' }
        format.json { render json: @motivos_dev_cheque, status: :created, location: @motivos_dev_cheque }
      else
        format.html { render action: "new" }
        format.json { render json: @motivos_dev_cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /motivos_dev_cheques/1
  # PUT /motivos_dev_cheques/1.json
  def update
    @motivos_dev_cheque = MotivosDevCheque.find(params[:id])

    respond_to do |format|
      if @motivos_dev_cheque.update_attributes(params[:motivos_dev_cheque])
        format.html { redirect_to @motivos_dev_cheque, notice: 'Motivos dev cheque was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @motivos_dev_cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motivos_dev_cheques/1
  # DELETE /motivos_dev_cheques/1.json
  def destroy
    @motivos_dev_cheque = MotivosDevCheque.find(params[:id])
    @motivos_dev_cheque.destroy

    respond_to do |format|
      format.html { redirect_to motivos_dev_cheques_url }
      format.json { head :no_content }
    end
  end
end

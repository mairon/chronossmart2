class ContaChequesController < ApplicationController
  # GET /conta_cheques
  # GET /conta_cheques.json
  def index
    @conta_cheques = ContaCheque.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conta_cheques }
    end
  end

  # GET /conta_cheques/1
  # GET /conta_cheques/1.json
  def show
    @conta_cheque = ContaCheque.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conta_cheque }
    end
  end

  # GET /conta_cheques/new
  # GET /conta_cheques/new.json
  def new
    @conta_cheque = ContaCheque.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conta_cheque }
    end
  end

  # GET /conta_cheques/1/edit
  def edit
    @conta_cheque = ContaCheque.find(params[:id])
  end

  # POST /conta_cheques
  # POST /conta_cheques.json
  def create
    @conta_cheque = ContaCheque.new(params[:conta_cheque])

    respond_to do |format|
      if @conta_cheque.save
        format.html { redirect_to conta_path(@conta_cheque.conta_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /conta_cheques/1
  # PUT /conta_cheques/1.json
  def update
    @conta_cheque = ContaCheque.find(params[:id])

    respond_to do |format|
      if @conta_cheque.update_attributes(params[:conta_cheque])
        format.html { redirect_to conta_path(@conta_cheque.conta_id) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conta_cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conta_cheques/1
  # DELETE /conta_cheques/1.json
  def destroy
    @conta_cheque = ContaCheque.find(params[:id])
    @conta_cheque.destroy

    respond_to do |format|
      format.html { redirect_to conta_path(@conta_cheque.conta_id) }
      format.json { head :no_content }
    end
  end
end

class DevChequeClienteDtsController < ApplicationController
  # GET /dev_cheque_cliente_dts
  # GET /dev_cheque_cliente_dts.json
  def index
    @dev_cheque_cliente_dts = DevChequeClienteDt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dev_cheque_cliente_dts }
    end
  end

  # GET /dev_cheque_cliente_dts/1
  # GET /dev_cheque_cliente_dts/1.json
  def show
    @dev_cheque_cliente_dt = DevChequeClienteDt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dev_cheque_cliente_dt }
    end
  end

  # GET /dev_cheque_cliente_dts/new
  # GET /dev_cheque_cliente_dts/new.json
  def new
    @dev_cheque_cliente_dt = DevChequeClienteDt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dev_cheque_cliente_dt }
    end
  end

  # GET /dev_cheque_cliente_dts/1/edit
  def edit
    @dev_cheque_cliente_dt = DevChequeClienteDt.find(params[:id])
  end

  # POST /dev_cheque_cliente_dts
  # POST /dev_cheque_cliente_dts.json
  def create
    @dev_cheque_cliente_dt = DevChequeClienteDt.new(params[:dev_cheque_cliente_dt])

    respond_to do |format|
      if @dev_cheque_cliente_dt.save
        format.html { redirect_to @dev_cheque_cliente_dt, notice: 'Dev cheque cliente dt was successfully created.' }
        format.json { render json: @dev_cheque_cliente_dt, status: :created, location: @dev_cheque_cliente_dt }
      else
        format.html { render action: "new" }
        format.json { render json: @dev_cheque_cliente_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dev_cheque_cliente_dts/1
  # PUT /dev_cheque_cliente_dts/1.json
  def update
    @dev_cheque_cliente_dt = DevChequeClienteDt.find(params[:id])

    respond_to do |format|
      if @dev_cheque_cliente_dt.update_attributes(params[:dev_cheque_cliente_dt])
        format.html { redirect_to @dev_cheque_cliente_dt, notice: 'Dev cheque cliente dt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dev_cheque_cliente_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dev_cheque_cliente_dts/1
  # DELETE /dev_cheque_cliente_dts/1.json
  def destroy
    @dev_cheque_cliente_dt = DevChequeClienteDt.find(params[:id])
    @dev_cheque_cliente_dt.destroy

    respond_to do |format|
      format.html { redirect_to dev_cheque_cliente_path(@dev_cheque_cliente_dt.dev_cheque_cliente_id) }
      format.json { head :no_content }
    end
  end
end

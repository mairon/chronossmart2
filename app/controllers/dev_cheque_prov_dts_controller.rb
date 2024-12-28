class DevChequeProvDtsController < ApplicationController
  # GET /dev_cheque_prov_dts
  # GET /dev_cheque_prov_dts.json
  def index
    @dev_cheque_prov_dts = DevChequeProvDt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dev_cheque_prov_dts }
    end
  end

  # GET /dev_cheque_prov_dts/1
  # GET /dev_cheque_prov_dts/1.json
  def show
    @dev_cheque_prov_dt = DevChequeProvDt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dev_cheque_prov_dt }
    end
  end

  # GET /dev_cheque_prov_dts/new
  # GET /dev_cheque_prov_dts/new.json
  def new
    @dev_cheque_prov_dt = DevChequeProvDt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dev_cheque_prov_dt }
    end
  end

  # GET /dev_cheque_prov_dts/1/edit
  def edit
    @dev_cheque_prov_dt = DevChequeProvDt.find(params[:id])
  end

  # POST /dev_cheque_prov_dts
  # POST /dev_cheque_prov_dts.json
  def create
    @dev_cheque_prov_dt = DevChequeProvDt.new(params[:dev_cheque_prov_dt])

    respond_to do |format|
      if @dev_cheque_prov_dt.save
        format.html { redirect_to @dev_cheque_prov_dt, notice: 'Dev cheque prov dt was successfully created.' }
        format.json { render json: @dev_cheque_prov_dt, status: :created, location: @dev_cheque_prov_dt }
      else
        format.html { render action: "new" }
        format.json { render json: @dev_cheque_prov_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dev_cheque_prov_dts/1
  # PUT /dev_cheque_prov_dts/1.json
  def update
    @dev_cheque_prov_dt = DevChequeProvDt.find(params[:id])

    respond_to do |format|
      if @dev_cheque_prov_dt.update_attributes(params[:dev_cheque_prov_dt])
        format.html { redirect_to @dev_cheque_prov_dt, notice: 'Dev cheque prov dt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dev_cheque_prov_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dev_cheque_prov_dts/1
  # DELETE /dev_cheque_prov_dts/1.json
  def destroy
    @dev_cheque_prov_dt = DevChequeProvDt.find(params[:id])
    @dev_cheque_prov_dt.destroy

    respond_to do |format|
      format.html { redirect_to dev_cheque_prov_path(@dev_cheque_prov_dt.dev_cheque_prov_id) }
      format.json { head :no_content }
    end
  end
end

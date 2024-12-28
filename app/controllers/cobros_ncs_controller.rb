class CobrosNcsController < ApplicationController
  # GET /cobros_ncs
  # GET /cobros_ncs.json
  def index
    @cobros_ncs = CobrosNc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cobros_ncs }
    end
  end

  # GET /cobros_ncs/1
  # GET /cobros_ncs/1.json
  def show
    @cobros_nc = CobrosNc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cobros_nc }
    end
  end

  # GET /cobros_ncs/new
  # GET /cobros_ncs/new.json
  def new
    @cobros_nc = CobrosNc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cobros_nc }
    end
  end

  # GET /cobros_ncs/1/edit
  def edit
    @cobros_nc = CobrosNc.find(params[:id])
  end

  # POST /cobros_ncs
  # POST /cobros_ncs.json
  def create
    @cobros_nc = CobrosNc.new(params[:cobros_nc])

    respond_to do |format|
      if @cobros_nc.save
        format.html { redirect_to "/cobros/#{@cobros_nc.cobro_id}/cobro_final" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /cobros_ncs/1
  # PUT /cobros_ncs/1.json
  def update
    @cobros_nc = CobrosNc.find(params[:id])

    respond_to do |format|
      if @cobros_nc.update_attributes(params[:cobros_nc])
        format.html { redirect_to "/cobros/#{@cobros_nc.cobro_id}/cobro_final" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /cobros_ncs/1
  # DELETE /cobros_ncs/1.json
  def destroy
    @cobros_nc = CobrosNc.find(params[:id])
    @cobros_nc.destroy

    respond_to do |format|
      format.html { redirect_to "/cobros/#{@cobros_nc.cobro_id}/cobro_final" }
      format.json { head :no_content }
    end
  end
end

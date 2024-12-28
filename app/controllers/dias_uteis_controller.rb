class DiasUteisController < ApplicationController
  # GET /dias_uteis
  # GET /dias_uteis.json
  def index
    @dias_uteis = DiasUtei.order('data')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dias_uteis }
    end
  end

  # GET /dias_uteis/1
  # GET /dias_uteis/1.json
  def show
    @dias_utei = DiasUtei.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dias_utei }
    end
  end

  # GET /dias_uteis/new
  # GET /dias_uteis/new.json
  def new
    @dias_utei = DiasUtei.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dias_utei }
    end
  end

  # GET /dias_uteis/1/edit
  def edit
    @dias_utei = DiasUtei.find(params[:id])
  end

  # POST /dias_uteis
  # POST /dias_uteis.json
  def create
    @dias_utei = DiasUtei.new(params[:dias_utei])

    respond_to do |format|
      if @dias_utei.save
        format.html { redirect_to dias_uteis_url }
        format.json { render json: @dias_utei, status: :created, location: @dias_utei }
      else
        format.html { render action: "new" }
        format.json { render json: @dias_utei.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dias_uteis/1
  # PUT /dias_uteis/1.json
  def update
    @dias_utei = DiasUtei.find(params[:id])

    respond_to do |format|
      if @dias_utei.update_attributes(params[:dias_utei])
        format.html { redirect_to dias_uteis_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dias_utei.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dias_uteis/1
  # DELETE /dias_uteis/1.json
  def destroy
    @dias_utei = DiasUtei.find(params[:id])
    @dias_utei.destroy

    respond_to do |format|
      format.html { redirect_to dias_uteis_url }
      format.json { head :no_content }
    end
  end
end

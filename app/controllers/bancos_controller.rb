class BancosController < ApplicationController
  # GET /bancos
  # GET /bancos.json
  def index
    @bancos = Banco.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bancos }
    end
  end

  # GET /bancos/1
  # GET /bancos/1.json
  def show
    @banco = Banco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @banco }
    end
  end

  # GET /bancos/new
  # GET /bancos/new.json
  def new
    @banco = Banco.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @banco }
    end
  end

  # GET /bancos/1/edit
  def edit
    @banco = Banco.find(params[:id])
  end

  # POST /bancos
  # POST /bancos.json
  def create
    @banco = Banco.new(params[:banco])

    respond_to do |format|
      if @banco.save
        format.html { redirect_to @banco, notice: 'Banco was successfully created.' }
        format.json { render json: @banco, status: :created, location: @banco }
      else
        format.html { render action: "new" }
        format.json { render json: @banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bancos/1
  # PUT /bancos/1.json
  def update
    @banco = Banco.find(params[:id])

    respond_to do |format|
      if @banco.update_attributes(params[:banco])
        format.html { redirect_to @banco, notice: 'Banco was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bancos/1
  # DELETE /bancos/1.json
  def destroy
    @banco = Banco.find(params[:id])
    @banco.destroy

    respond_to do |format|
      format.html { redirect_to bancos_url }
      format.json { head :no_content }
    end
  end
end

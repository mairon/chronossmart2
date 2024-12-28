class CartaosController < ApplicationController
  # GET /cartaos
  # GET /cartaos.json
  def index
    @cartaos = Cartao.where(unidade_id: current_unidade.id).order("cast(coalesce(nome,'0') as integer)")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cartaos }
    end
  end

  # GET /cartaos/1
  # GET /cartaos/1.json
  def show
    @cartao = Cartao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cartao }
    end
  end

  # GET /cartaos/new
  # GET /cartaos/new.json
  def new
    @cartao = Cartao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cartao }
    end
  end

  # GET /cartaos/1/edit
  def edit
    @cartao = Cartao.find(params[:id])
  end

  # POST /cartaos
  # POST /cartaos.json
  def create
    @cartao = Cartao.new(params[:cartao])
    @cartao.unidade_id = current_unidade.id

    respond_to do |format|
      if @cartao.save
        format.html { redirect_to cartaos_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /cartaos/1
  # PUT /cartaos/1.json
  def update
    @cartao = Cartao.find(params[:id])

    respond_to do |format|
      if @cartao.update_attributes(params[:cartao])
        format.html { redirect_to cartaos_url }

      else
        format.html { render action: "edit" }

      end
    end
  end

  # DELETE /cartaos/1
  # DELETE /cartaos/1.json
  def destroy
    @cartao = Cartao.find(params[:id])
    @cartao.destroy

    respond_to do |format|
      format.html { redirect_to cartaos_url }
      format.json { head :no_content }
    end
  end
end

class BicosController < ApplicationController
  # GET /bicos
  # GET /bicos.json
  def index
    @bicos = Bico.where("unidade_id = #{current_unidade.id}").order('ordem')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bicos }
    end
  end

  # GET /bicos/1
  # GET /bicos/1.json
  def show
    @bico = Bico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bico }
    end
  end

  # GET /bicos/new
  # GET /bicos/new.json
  def new
    @bico = Bico.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bico }
    end
  end

  # GET /bicos/1/edit
  def edit
    @bico = Bico.find(params[:id])
  end

  # POST /bicos
  # POST /bicos.json
  def create
    @bico = Bico.new(params[:bico])
    @bico.unidade_id = current_unidade.id.to_i
    respond_to do |format|
      if @bico.save
        format.html { redirect_to bicos_url }
        format.json { render json: @bico, status: :created, location: @bico }
      else
        format.html { render action: "new" }
        format.json { render json: @bico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bicos/1
  # PUT /bicos/1.json
  def update
    @bico = Bico.find(params[:id])

    respond_to do |format|
      if @bico.update_attributes(params[:bico])
        format.html { redirect_to bicos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bicos/1
  # DELETE /bicos/1.json
  def destroy
    @bico = Bico.find(params[:id])
    @bico.destroy

    respond_to do |format|
      format.html { redirect_to bicos_url }
      format.json { head :no_content }
    end
  end
end

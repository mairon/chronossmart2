class RetencaosController < ApplicationController
  # GET /retencaos
  # GET /retencaos.json
  def index
    @retencaos = Retencao.where("unidade_id = #{current_unidade.id}").order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @retencaos }
    end
  end

  # GET /retencaos/1
  # GET /retencaos/1.json
  def show
    params[:unidade] = current_unidade.id
    @retencao = Retencao.find(params[:id])
    params[:persona] =  @retencao.persona_id
    @faturas = Retencao.faturas(params)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @retencao }
    end
  end

  # GET /retencaos/new
  # GET /retencaos/new.json
  def new
    @retencao = Retencao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @retencao }
    end
  end

  # GET /retencaos/1/edit
  def edit
    @retencao = Retencao.find(params[:id])
  end

  # POST /retencaos
  # POST /retencaos.json
  def create
    @retencao = Retencao.new(params[:retencao])
    @retencao.unidade_id = current_unidade.id.to_i
    @retencao.usuario_created = current_user.id.to_i
    @retencao.unidade_created = current_unidade.id.to_i

    respond_to do |format|
      if @retencao.save
        format.html { redirect_to @retencao, notice: 'Retencao was successfully created.' }
        format.json { render json: @retencao, status: :created, location: @retencao }
      else
        format.html { render action: "new" }
        format.json { render json: @retencao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /retencaos/1
  # PUT /retencaos/1.json
  def update
    @retencao = Retencao.find(params[:id])

    @retencao.usuario_updated = current_user.id.to_i
    @retencao.unidade_updated = current_unidade.id.to_i

    respond_to do |format|
      if @retencao.update_attributes(params[:retencao])
        format.html { redirect_to @retencao, notice: 'Retencao was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @retencao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retencaos/1
  # DELETE /retencaos/1.json
  def destroy
    @retencao = Retencao.find(params[:id])
    @retencao.destroy

    respond_to do |format|
      format.html { redirect_to retencaos_url }
      format.json { head :no_content }
    end
  end
end

class UnidadesUsuariosController < ApplicationController
  # GET /unidades_usuarios
  # GET /unidades_usuarios.json
  def index
    @unidades_usuarios = UnidadesUsuario.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @unidades_usuarios }
    end
  end

  # GET /unidades_usuarios/1
  # GET /unidades_usuarios/1.json
  def show
    @unidades_usuario = UnidadesUsuario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @unidades_usuario }
    end
  end

  # GET /unidades_usuarios/new
  # GET /unidades_usuarios/new.json
  def new
    @unidades_usuario = UnidadesUsuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @unidades_usuario }
    end
  end

  # GET /unidades_usuarios/1/edit
  def edit
    @unidades_usuario = UnidadesUsuario.find(params[:id])
  end

  # POST /unidades_usuarios
  # POST /unidades_usuarios.json
  def create
    @unidades_usuario = UnidadesUsuario.new(params[:unidades_usuario])

    respond_to do |format|
      if @unidades_usuario.save
        format.html { redirect_to @unidades_usuario, notice: 'Unidades usuario was successfully created.' }
        format.json { render json: @unidades_usuario, status: :created, location: @unidades_usuario }
      else
        format.html { render action: "new" }
        format.json { render json: @unidades_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /unidades_usuarios/1
  # PUT /unidades_usuarios/1.json
  def update
    @unidades_usuario = UnidadesUsuario.find(params[:id])

    respond_to do |format|
      if @unidades_usuario.update_attributes(params[:unidades_usuario])
        format.html { redirect_to @unidades_usuario, notice: 'Unidades usuario was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @unidades_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unidades_usuarios/1
  # DELETE /unidades_usuarios/1.json
  def destroy
    @unidades_usuario = UnidadesUsuario.find(params[:id])
    @unidades_usuario.destroy

    respond_to do |format|
      format.html { redirect_to unidades_usuarios_url }
      format.json { head :no_content }
    end
  end
end

class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end


  def auth
    @user = User.where(email: params[:login], mobile_auth: params[:mobile_auth]).first
    if @user
      render json: {
          status: 'Autenticado',
          host: @user.host,
          port: @user.port,
          db: @user.db
        }
    else
      render json: {
            status: 'Não Autenticado'
          }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to "/users" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    sql =  "SELECT  personas.id, personas.nome FROM personas"
    @personas_user = Persona.find_by_sql(sql)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to "/users"}
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to "/users}"}
      format.json { head :no_content }
    end
  end
  def get_personas
    sql = "SELECT id, nome FROM personas"
    get_persona = Persona.find_by_sql(sql)
  end
end

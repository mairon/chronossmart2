class DepositosController < ApplicationController
  # GET /depositos
  # GET /depositos.xml
  def index
    @depositos = Deposito.where("unidade_id = ?", current_unidade.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @depositos }
    end
  end

  # GET /depositos/1
  # GET /depositos/1.xml
  def show
    @deposito = Deposito.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deposito }
    end
  end

  # GET /depositos/new
  # GET /depositos/new.xml
  def new
    @deposito = Deposito.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deposito }
    end
  end

  # GET /depositos/1/edit
  def edit
    @deposito = Deposito.find(params[:id])
  end

  # POST /depositos
  # POST /depositos.xml
  def create
    @deposito = Deposito.new(params[:deposito])

    respond_to do |format|
      if @deposito.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
          format.html { redirect_to (depositos_url) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deposito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /depositos/1
  # PUT /depositos/1.xml
  def update
    @deposito = Deposito.find(params[:id])

    respond_to do |format|
      if @deposito.update_attributes(params[:deposito])
        format.html { redirect_to (depositos_url) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deposito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /depositos/1
  # DELETE /depositos/1.xml
  def destroy
    @deposito = Deposito.find(params[:id])
    @deposito.destroy

    respond_to do |format|
      format.html { redirect_to (depositos_url) }
      format.xml  { head :ok }
    end
  end
end

class ChequeDiferidosController < ApplicationController
  # GET /cheque_diferidos
  # GET /cheque_diferidos.xml
  def index
    @cheque_diferidos = ChequeDiferido.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cheque_diferidos }
    end
  end

  # GET /cheque_diferidos/1
  # GET /cheque_diferidos/1.xml
  def show
    @cheque_diferido = ChequeDiferido.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cheque_diferido }
    end
  end

  # GET /cheque_diferidos/new
  # GET /cheque_diferidos/new.xml
  def new
    @cheque_diferido = ChequeDiferido.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cheque_diferido }
    end
  end

  # GET /cheque_diferidos/1/edit
  def edit
    @cheque_diferido = ChequeDiferido.find(params[:id])
  end

  # POST /cheque_diferidos
  # POST /cheque_diferidos.xml
  def create
    @cheque_diferido = ChequeDiferido.new(params[:cheque_diferido])

    respond_to do |format|
      if @cheque_diferido.save
        format.html { redirect_to(@cheque_diferido, :notice => 'ChequeDiferido was successfully created.') }
        format.xml  { render :xml => @cheque_diferido, :status => :created, :location => @cheque_diferido }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cheque_diferido.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cheque_diferidos/1
  # PUT /cheque_diferidos/1.xml
  def update
    @cheque_diferido = ChequeDiferido.find(params[:id])

    respond_to do |format|
      if @cheque_diferido.update_attributes(params[:cheque_diferido])
        format.html { redirect_to(@cheque_diferido, :notice => 'ChequeDiferido was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cheque_diferido.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cheque_diferidos/1
  # DELETE /cheque_diferidos/1.xml
  def destroy
    @cheque_diferido = ChequeDiferido.find(params[:id])
    @cheque_diferido.destroy

    respond_to do |format|
      format.html { redirect_to(cheque_diferidos_url) }
      format.xml  { head :ok }
    end
  end
end

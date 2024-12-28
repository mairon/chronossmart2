class NotaCreditoProveedorAplicsController < ApplicationController
  # GET /nota_credito_proveedor_aplics
  # GET /nota_credito_proveedor_aplics.xml
  def index
    @nota_credito_proveedor_aplics = NotaCreditoProveedorAplic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nota_credito_proveedor_aplics }
    end
  end

  # GET /nota_credito_proveedor_aplics/1
  # GET /nota_credito_proveedor_aplics/1.xml
  def show
    @nota_credito_proveedor_aplic = NotaCreditoProveedorAplic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota_credito_proveedor_aplic }
    end
  end

  # GET /nota_credito_proveedor_aplics/new
  # GET /nota_credito_proveedor_aplics/new.xml
  def new
    @nota_credito_proveedor_aplic = NotaCreditoProveedorAplic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota_credito_proveedor_aplic }
    end
  end

  # GET /nota_credito_proveedor_aplics/1/edit
  def edit
    @nota_credito_proveedor_aplic = NotaCreditoProveedorAplic.find(params[:id])
  end

  # POST /nota_credito_proveedor_aplics
  # POST /nota_credito_proveedor_aplics.xml
  def create
    @nota_credito_proveedor_aplic = NotaCreditoProveedorAplic.new(params[:nota_credito_proveedor_aplic])

    respond_to do |format|
      if @nota_credito_proveedor_aplic.save
        format.html { redirect_to("/nota_credito_proveedors/#{@nota_credito_proveedor_aplic.nota_credito_proveedor_id}/nc_proveedor_aplic") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /nota_credito_proveedor_aplics/1
  # PUT /nota_credito_proveedor_aplics/1.xml
  def update
    @nota_credito_proveedor_aplic = NotaCreditoProveedorAplic.find(params[:id])

    respond_to do |format|
      if @nota_credito_proveedor_aplic.update_attributes(params[:nota_credito_proveedor_aplic])
        format.html { redirect_to("/nota_credito_proveedors/#{@nota_credito_proveedor_aplic.nota_credito_proveedor_id}/nc_proveedor_aplic") }
        
      else
        format.html { render :action => "edit" }
        
      end
    end
  end

  # DELETE /nota_credito_proveedor_aplics/1
  # DELETE /nota_credito_proveedor_aplics/1.xml
  def destroy
    @nota_credito_proveedor_aplic = NotaCreditoProveedorAplic.find(params[:id])
    @nota_credito_proveedor_aplic.destroy

    respond_to do |format|
      format.html { redirect_to("/nota_credito_proveedors/#{@nota_credito_proveedor_aplic.nota_credito_proveedor_id}/nc_proveedor_aplic") }
      format.xml  { head :ok }
    end
  end
end

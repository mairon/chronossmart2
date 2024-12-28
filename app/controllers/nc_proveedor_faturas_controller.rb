class NcProveedorFaturasController < ApplicationController
  before_filter :authenticate

  def index
    @nc_proveedor_faturas = NcProveedorFatura.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nc_proveedor_faturas }
    end
  end

  def show
    @nc_proveedor_fatura = NcProveedorFatura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nc_proveedor_fatura }
    end
  end

  def new
    @nc_proveedor_fatura = NcProveedorFatura.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nc_proveedor_fatura }
    end
  end

  def edit
    @nc_proveedor_fatura = NcProveedorFatura.find(params[:id])
  end

  def create
    @nc_proveedor_fatura = NcProveedorFatura.new(params[:nc_proveedor_fatura])

    respond_to do |format|
      if @nc_proveedor_fatura.save
        format.html { redirect_to("/nota_credito_proveedors/#{@nc_proveedor_fatura.nota_credito_proveedor_id}")}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @nc_proveedor_fatura = NcProveedorFatura.find(params[:id])

    respond_to do |format|
      if @nc_proveedor_fatura.update_attributes(params[:nc_proveedor_fatura])
        format.html { redirect_to("/nota_credito_proveedors/#{@nc_proveedor_fatura.nota_credito_proveedor_id}" )}
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @nc_proveedor_fatura = NcProveedorFatura.find(params[:id])
    @nc_proveedor_fatura.destroy

    respond_to do |format|
        format.html { redirect_to("/nota_credito_proveedors/#{@nc_proveedor_fatura.nota_credito_proveedor_id}" )}
    end
  end
end

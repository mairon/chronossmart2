class PagosDetalhesController < ApplicationController
before_filter :authenticate

  def index
    @pagos_detalhes = PagosDetalhe.where(documento_numero: 'PROV40-4')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pagos_detalhes }
    end
  end

  # GET /pagos_detalhes/1
  # GET /pagos_detalhes/1.xml
  def show
    @pagos_detalhe = PagosDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pagos_detalhe }
    end
  end

  # GET /pagos_detalhes/new
  # GET /pagos_detalhes/new.xml
  def new
    @pagos_detalhe = PagosDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pagos_detalhe }
    end
  end

  # GET /pagos_detalhes/1/edit
  def edit
    @pagos_detalhe = PagosDetalhe.find(params[:id])
  end

  # POST /pagos_detalhes
  # POST /pagos_detalhes.xml
  def create
    @pagos_detalhe = PagosDetalhe.new(params[:pagos_detalhe])
    @pagos_detalhe.usuario_created = current_user.id
    @pagos_detalhe.unidade_created = current_unidade.id


    respond_to do |format|
      if @pagos_detalhe.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to "/pagos/#{@pagos_detalhe.pago_id}" }
        format.xml  { render :xml => @pagos_detalhe, :status => :created, :location => @pagos_detalhe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pagos_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pagos_detalhes/1
  # PUT /pagos_detalhes/1.xml
  def update
    @pagos_detalhe = PagosDetalhe.find(params[:id])
    @pagos_detalhe.usuario_updated = current_user.id
    @pagos_detalhe.unidade_updated = current_unidade.id

    respond_to do |format|
      if @pagos_detalhe.update_attributes(params[:pagos_detalhe])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to "/pagos/#{@pagos_detalhe.pago_id}" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pagos_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pagos_detalhes/1
  # DELETE /pagos_detalhes/1.xml
  def destroy
    @pagos_detalhe = PagosDetalhe.find(params[:id])
    @pagos_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to "/pagos/#{@pagos_detalhe.pago_id}" }
      format.xml  { head :ok }
    end
  end
end

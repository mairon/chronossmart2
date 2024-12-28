class PlanoVendasController < ApplicationController

  def comprovante
      @plano_venda = PlanoVenda.find(params[:id])


    respond_to do |format|
          format.html do
            render  :pdf                    => "Plan-de-Venta-#{@plano_venda.id}",                
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '0.20in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},        
                    :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :spacing    => 19},
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "Chronos Software - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
  end

  def update_individual
    PlanoVendaCond.update(params[:conds].keys, params[:conds].values)
    redirect_to plano_venda_path(params[:id])
  end

  def index
    @plano_vendas = PlanoVenda.order('id desc')
    
    render layout: 'chart'
  end

  def show
    @plano_venda = PlanoVenda.find(params[:id])

    render layout: 'chart'
  end

  # GET /plano_vendas/new
  # GET /plano_vendas/new.json
  def new
    @plano_venda = PlanoVenda.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plano_venda }
    end
  end

  # GET /plano_vendas/1/edit
  def edit
    @plano_venda = PlanoVenda.find(params[:id])
  end

  # POST /plano_vendas
  # POST /plano_vendas.json
  def create
    @plano_venda = PlanoVenda.new(params[:plano_venda])

    respond_to do |format|
      if @plano_venda.save
        format.html { redirect_to @plano_venda }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /plano_vendas/1
  # PUT /plano_vendas/1.json
  def update
    @plano_venda = PlanoVenda.find(params[:id])

    respond_to do |format|
      if @plano_venda.update_attributes(params[:plano_venda])
        format.html { redirect_to @plano_venda }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /plano_vendas/1
  # DELETE /plano_vendas/1.json
  def destroy
    @plano_venda = PlanoVenda.find(params[:id])
    @plano_venda.destroy

    respond_to do |format|
      format.html { redirect_to plano_vendas_url }
    end
  end
end

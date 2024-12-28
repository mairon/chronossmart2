class FaturasController < ApplicationController
  before_filter :authenticate

  def multi_faturas
    unless params[:inicio].blank?
      @titulos = Cliente.where("liquidacao = 0 and tabela = 'CONTRATOS' and VENCIMENTO BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' ")
    else
    end
    render layout: 'chart'
  end

  def print_busca

        @faturas = Fatura.filtro(params)

        head =
        "                                                                                    #{$empresa_nome}
                                                                                                FACTURAS
    Fecha : #{params[:inicio]} Hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Cod.       Fecha     Status  Documento                     Cliente                                                                Total U$.          Gs.     Tipo
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "


    respond_to do |format|
      format.html do
        render  :pdf                    => "print_busca",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end    
    end

  def index
    @faturas = Fatura.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @faturas }
    end
  end

  def show
    @fatura = Fatura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fatura }
    end
  end

  def new
    @fatura = Fatura.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fatura }
    end
  end

  def edit
    @fatura = Fatura.find(params[:id])
  end

  def create
    @fatura = Fatura.new(params[:fatura])

    respond_to do |format|
      if @fatura.save
      format.html { redirect_to(faturas_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @fatura = Fatura.find(params[:id])

    respond_to do |format|
      if @fatura.update_attributes(params[:fatura])
      format.html { redirect_to(faturas_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @fatura = Fatura.find(params[:id])
    @fatura.destroy

    respond_to do |format|
      format.html { redirect_to(faturas_url) }
    end
  end
end

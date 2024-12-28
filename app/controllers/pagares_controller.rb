class PagaresController < ApplicationController
  before_filter :authenticate
  def get_moeda           #
    @moeda =  Moeda.find(:first,:select => 'dolar_compra', :conditions =>  [ "data = ?", params[:key]])
    return render :text => "<script type='text/javascript'>
                               document.getElementById('pagare_cotacao').value       = '#{@moeda.dolar_compra.to_i}';
                            </script>"
  end


  def index
    @pagares = Pagare.all(:conditions => ["tabela_id is null"], :order => 'data DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pagares }
    end
  end

  # GET /pagares/1
  # GET /pagares/1.xml
  def show
    @pagare = Pagare.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pagare }
    end
  end

  def print
    @pagare = Pagare.find(params[:id])
    @pd = PagaresDetalhe.all(:conditions => ["pagare_id = ?",params[:id]],:order => 'vencimento')


        respond_to do |format|
          format.html do
            render  :pdf                    => "resultado_fechamento_caixa",                
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '1.20in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},        
                    :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :spacing    => 25},
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
  end

  def contrato
    @pagare = Pagare.find(params[:id])

    @pd = PagaresDetalhe.all(:conditions => ["pagare_id = ?",params[:id]],:order => 'vencimento')

    respond_to do |format|
      format.html {render :layout => false}
      format.xml  { render :xml => @pagare }
    end
  end

  def autorizacao_desc
    @pagare = Pagare.find(params[:id])

    @pd = PagaresDetalhe.all(:conditions => ["pagare_id = ?",params[:id]],:order => 'vencimento')

    pdf = render :layout => 'layer_relatorios'
    kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "5",
                :footer_font_size  => "7",
                :margin_top    => '0.10in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')

            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Autorizacion_#{@pagare.id}.pdf")
  end

  # GET /pagares/new
  # GET /pagares/new.xml
  def new
    @pagare = Pagare.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pagare }
    end
  end

  # GET /pagares/1/edit
  def edit
    @pagare = Pagare.find(params[:id])
  end

  # POST /pagares
  # POST /pagares.xml
  def create
    @pagare = Pagare.new(params[:pagare])

    respond_to do |format|
      if @pagare.save
        format.html { redirect_to(@pagare, :notice => 'Pagare was successfully created.') }
        format.xml  { render :xml => @pagare, :status => :created, :location => @pagare }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pagare.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pagares/1
  # PUT /pagares/1.xml
  def update
    @pagare = Pagare.find(params[:id])

    respond_to do |format|
      if @pagare.update_attributes(params[:pagare])
        format.html { redirect_to(@pagare, :notice => 'Pagare was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pagare.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pagares/1
  # DELETE /pagares/1.xml
  def destroy
    @pagare = Pagare.find(params[:id])
    @pagare.destroy

    respond_to do |format|
      format.html { redirect_to(pagares_url) }
      format.xml  { head :ok }
    end
  end
end

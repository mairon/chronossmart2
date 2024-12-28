class AdelantosController < ApplicationController

  before_filter :authenticate

  def liquidacao
    @adelanto    = Adelanto.find(params[:id])

    respond_to do |format|
      format.html do
        render  :pdf                    => "liquidacao",
                :layout                 => "layer_relatorios",
                :page_size => 'Legal',
                :margin => {:top        => '0.05in',
                            :bottom     => '0.10in',
                            :left       => '0.10in',
                            :right      => '0.10in'},

                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end

  end

  def gerar_cotas_credito
    @adelanto    = Adelanto.find(params[:id])
    Adelanto.gerador_cotas(params)
    redirect_to("/adelantos/"<< @adelanto.id.to_s)
  end

  def recibo          #
    @adelanto    = Adelanto.find(params[:id])
    render  :layout => false
  end

  def comprovante          #
    @adelanto    = Adelanto.find(params[:id])
    @adelanto_cotas = AdelantoCota.where('adelanto_id = ?', @adelanto.id)
    render  :layout => false
  end

  def index               #
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def busca               #
    params[:unidade] = current_unidade.id
    @adelantos = Adelanto.filtro_busca(params)
    render :layout => false
  end

  def show
    @adelanto = Adelanto.find(params[:id])
    @rds = FormFiscal.where("status != 0 and sigla_proc = 'AD' AND cod_proc = #{@adelanto.id} and tipo_doc = 15").select("id, tot_gs, doc_01, doc_02, doc, status")
    render layout: 'chart'
  end

  def new                 #
    @adelanto = Adelanto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @adelanto }
    end
  end

  def edit                #
    @adelanto = Adelanto.find(params[:id])
  end

  def create              #
    @adelanto = Adelanto.new(params[:adelanto])
    @adelanto.usuario_created = current_user.id
    @adelanto.unidade_created = current_unidade.id

    @adelanto.unidade_id = current_unidade.id

    respond_to do |format|
      if @adelanto.save
        format.html { redirect_to(@adelanto, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @adelanto = Adelanto.find(params[:id])

    respond_to do |format|
      if @adelanto.update_attributes(params[:adelanto])
        format.html { redirect_to(@adelanto, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy             #
    @adelanto = Adelanto.find(params[:id])
    @adelanto.destroy

    respond_to do |format|
      format.html { redirect_to(adelantos_url) }
    end
  end
end

class SueldosController < ApplicationController
    before_filter :authenticate

    def baixa_divida
      @sueldo = Sueldo.find(params[:id])
      @dividas = Cliente.find(params[:cobro]["dividas_ids"])      
        @dividas.each do |d|
          anterior_gs = Cliente.sum(:cobro_guarani, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
          anterior_us = Cliente.sum(:cobro_dolar, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
          anterior_rs = Cliente.sum(:cobro_real, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])

          SueldosDetalhe.create(  sueldo_id:    @sueldo.id,
                                persona_id:  d.persona_id,
                                documento_numero_01: d.documento_numero_01,
                                documento_numero_02: d.documento_numero_02,
                                documento_numero:    d.documento_numero,
                                tipo: 'BAJA DEUDA',
                                cota:                d.cota,
                                data:                @sueldo.data_inicio,
                                moeda:               @sueldo.moeda,                           
                                debito_us:          d.divida_dolar.to_f  - anterior_us.to_f,
                                debito_gs:          d.divida_guarani.to_f - anterior_gs.to_f,
                                debito_rs:          d.divida_real.to_f - anterior_rs.to_f,
                                descricao: 'BAJA DEUDA'
                                )
        end

      redirect_to(sueldo_path(@sueldo))
    end

    def busca
      params[:unidade] = current_unidade.id
      @sueldos = Sueldo.filtro(params)
      render :layout => false
    end

    def liquidacao
      @sueldo = Sueldo.find(params[:id])
      if @sueldo.moeda == 0
          saldo = 'divida_dolar - cobro_dolar'
      elsif @sueldo.moeda == 1
          saldo = 'divida_guarani - cobro_guarani'
      else
          saldo = 'divida_real - cobro_real'
      end
      @pendentes = Cliente.sum(saldo,:conditions => ["persona_id = ?  AND liquidacao = 0  AND tipo = '1' and data <= ?",@sueldo.persona_id,@sueldo.data_final])

      @sueldos_detalhes = SueldosDetalhe.all(:conditions => ["sueldo_id = ?",@sueldo.id],:order => 'data,id')

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

    def financas
        @sueldo = Sueldo.find(params[:id])
        render layout: 'chart'
    end

    def result_gerar_sueldos
        Sueldo.gera_sueldos(params)
    end

    def comprovante
        @sueldo = Sueldo.find(params[:id])
        if @sueldo.moeda == 0
            saldo = 'divida_dolar - cobro_dolar'
        elsif @sueldo.moeda == 1
            saldo = 'divida_guarani - cobro_guarani'
        else
            saldo = 'divida_real - cobro_real'
        end
        @pendentes = Cliente.sum(saldo,:conditions => ["persona_id = ?  AND liquidacao = 0  AND tipo = '1' and data <= ?",@sueldo.persona_id,@sueldo.data_final])

        @sueldos_detalhes = SueldosDetalhe.all(:conditions => ["sueldo_id = ?",@sueldo.id],:order => 'data,id')

        render :layout => 'layer_relatorios'
    end

    def form_sueldos_detalhes
        @sueldo = Sueldo.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end

    #METHODS BASE-------------------------------------------------------------------
    def index
        @sueldos = Sueldo.order('data_inicio desc, id desc')

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @sueldos }
        end
    end

    def detalhes_financeiros
        @sueldo = Sueldo.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end

    def fim_detalhes
        @sueldo = Sueldo.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end


    def show
        @sueldo = Sueldo.find(params[:id])
        d = Date.new(@sueldo.data_inicio.strftime("%Y").to_i,@sueldo.data_inicio.strftime("%m").to_i)
        @pendentes = Cliente.all(:conditions => ["persona_id = ?  AND liquidacao = 0 AND (divida_guarani + divida_dolar + divida_real) > 0",@sueldo.persona_id   ],:order => 'data,id')
        render layout: 'chart'
    end

    def new
        @sueldo = Sueldo.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end

    def edit
        @sueldo = Sueldo.find(params[:id])
    end

    def create
        @sueldo = Sueldo.new(params[:sueldo])
        @sueldo.usuario_created = current_user.id
        @sueldo.unidade_created = current_unidade.id
        @sueldo.unidade_id = current_unidade.id

        respond_to do |format|
            if @sueldo.save
                format.html { redirect_to(@sueldo, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
                format.xml  { render :xml => @sueldo, :status => :created, :location => @sueldo }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @sueldo.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update
        @sueldo = Sueldo.find(params[:id])
        @sueldo.usuario_updated = current_user.id
        @sueldo.unidade_updated = current_unidade.id

        respond_to do |format|
            if @sueldo.update_attributes(params[:sueldo])
                format.html { redirect_to(@sueldo, :notice => t('SUCESSFUL_EDIT_MESSAGE')) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @sueldo.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        @sueldo = Sueldo.find(params[:id])
        @sueldo.destroy

        respond_to do |format|
            format.html { redirect_to(sueldos_url) }
            format.xml  { head :ok }
        end
    end
end

class ContabilidadesController < ApplicationController

  def resultado_livro_compra

        @compra = Contabilidade.livro_compra(params)

    respond_to do |format|
      if params[:tipo] == '1'
        format.html {

          xls = render_to_string :action => "resultado_livro_compra", :layout => false
          kit = PDFKit.new(xls,
                           :encoding => 'UTF-8')
          send_data(xls,:filename => "Livro-Compra.xls")
        }
      else
      format.html do
        render  :pdf                    => "resultado_livro_compra",                
                :layout                 => "layer_relatorios",
                :orientation                    => 'Landscape',
                :margin => {:top        => '0.25in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
      end
    end    
    end

    def resultado_livro_venda
      @venda = Contabilidade.livro_venda(params)
      respond_to do |format|
      if params[:tipo] == '1'
        format.html{ render xlsx: :resultado_livro_venda, filename: "Livro-Venta.xlsx" }       
      else

      format.html do
        render  :pdf                    => "resultado_livro_venda",
                :layout                 => "layer_relatorios",
                :orientation                    => 'Landscape',
                :margin => {:top        => '0.40in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end
    end

    def resultado_livro_diario                      #
        if params[:moeda] == '0'
            moeda = 'Dolar'
        else
            moeda = 'Guaranies'
        end

        head =
        "                                                       #{$empresa_nome}
                                                            LIBRO DIARIO
- #{t('DATE')}..: #{params[:inicio]} Hasta #{params[:final]}
- Moneda.: #{moeda}


-----------------------------------------------------------------------------------------------------------------------------------------
  #{t('DATE')}    Lanz.  Diario          Doc.         Cuenta   Concepto                                                    Debe           Haber        
-----------------------------------------------------------------------------------------------------------------------------------------
        "


        @diario = Contabilidade.livro_diario(params)

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_diario",                
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
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_livro_mayor
        params[:unidade] = current_unidade.id
        if params[:moeda] == '0'
            moeda = 'Dolar'
        else
            moeda = 'Guaranies'
        end
        rubro_descr = PlanoDeConta.find_by_codigo(params[:codigo_inicio])
        head =
        "                                                     #{$empresa_nome}
                                                     #{t('LISTING').upcase} PRELIMINAR DEL MAYOR ANALITICO
#{t('DATE')}..........: #{params[:inicio]} Hasta #{params[:final]}
Contabilidade..: #{params[:codigo_inicio]} - #{rubro_descr.descricao}
Moneda.........: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    #{t('DATE')}      Lanz.    Diario        Doc.      Concepto                                               Debe          Haber         Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
        "


        @diario = Contabilidade.livro_mayor(params)

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_mayor",                
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
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end


    def resultado_livro_mayor_produtos                       #

        head =
        "                                                                                    #{$empresa_nome}
                                                                                        LIBRO MAYOR
    Fecha : #{params[:inicio]} Hasta #{params[:final]}
    Contabilidade : #{params[:codigo]}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Cod.       #{t('DATE')}                   Proceso               N. Proceso         	Documento                        Debe            Haber                  Saldo
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "


        @diario = Contabilidade.livro_mayor_produtos(params)

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_mayor_produtos",                
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
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end



    def resultado_generar_acientos_contables        #

        @log = Contabilidade.generar_acientos_contables(params)

        render :layout => false
    end

    def resultado_balance
        params[:unidade] = current_unidade.id
        @balance = Contabilidade.balance(params)


        head =
        "                                               #{$empresa}
                                                        Balance de Sumas y Saldos
    Fecha : #{params[:inicio]} Hasta #{params[:final]}


------------------------------------------------------------------------------------------------------------------------------------------
Descripcion                                                                Anterior             Debe              Haber           Saldo
------------------------------------------------------------------------------------------------------------------------------------------
        "


    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_balance",
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
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_balance_general                   #

        @balance = Contabilidade.balance_general(params)


        head =
        "                                                                                    #{$empresa_nome}
                                                                                     Balance General
    Fecha : #{params[:inicio]} Hasta #{params[:final]}
        "


    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_balance_general",                
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
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end


    def resultado_resumo_compra                  #
    
        @compra =   Contabilidade.resumo_compra(params)    
        head =
        "                                                                                            #{$empresa_nome}
                                                                                    Resumen de Compra
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Descripcion                                           Exentas          Grav. 05           Impost. 05            Grav. 10       Impost. 10              Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_resumo_compra",                
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
                            :left       => "Chronos Software - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end


    def resultado_resumo_vendas                  #
    
        @venda =   Contabilidade.resumo_vendas(params)    
        head =
        "                                                        #{$empresa_nome}
                                                         Resumen de Vendas
- Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------
Descripcion                           Exentas           Grav. 05        Impost. 05          Grav. 10           Impost. 10          Total
-----------------------------------------------------------------------------------------------------------------------------------------
        "

        respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_resumo_vendas",                
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
                            :left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

end

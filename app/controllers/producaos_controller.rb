class ProducaosController < ApplicationController
    before_filter :authenticate


    def get_codigo  #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:codigo]])

        return render :text => "<script type='text/javascript'>
                                  document.getElementById('producao_produto_id').value             = '#{@produto.id.to_i}';
                                </script>"
    end

    def get_codigo_barra_produto  #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:codigo]])

        stock = Stock.sum( 'entrada - saida',:conditions => ['produto_id = ?',@produto.id] )
        unitario_us   = Stock.sum('entrada * unitario_dolar',:conditions => ["produto_id = ?  AND entrada > 0 ",@produto.id])
        unitario_gs   = Stock.sum('entrada * unitario_guarani',:conditions => ["produto_id = ? AND entrada > 0 ",@produto.id])
        quantidade    = Stock.sum('entrada',:conditions => ["produto_id = ? AND entrada > 0 ",@produto.id])
        if quantidade.to_f > 0
            promedio_us      = ( ( unitario_us.to_f ) / quantidade.to_f )
            promedio_gs      = ( ( unitario_gs.to_f ) / quantidade.to_f )
        else
            promedio_us      = 0
            promedio_gs      = 0
        end


        return render :text => "<script type='text/javascript'>
                                  document.getElementById('producao_produto_produto_id').value             = '#{@produto.id.to_i}';
                                  document.getElementById('producao_produto_produto_nome').value           = '#{@produto.nome.to_s}';
                                  document.getElementById('producao_produto_clase_id').value               = '#{@produto.clase_id.to_i}';
                                  document.getElementById('producao_produto_grupo_id').value               = '#{@produto.grupo_id.to_i}';
                                  document.getElementById('producao_produto_sub_grupo_id').value           = '#{@produto.sub_grupo_id.to_i}';
                                  document.getElementById('producao_produto_custo_dolar').value             =  number_format( #{promedio_us},2, ',', '.')
                                  document.getElementById('producao_produto_custo_guarani').value           = number_format( #{promedio_gs},0, ',', '.');

                                   if ( '#{stock}' <= 0 )
                                     {
                                      document.getElementById('red').innerHTML                             =  '<span>'+'#{stock}'+'</span>' ;
                                      document.getElementById('green').innerHTML                           =  '' ;
                                     }
                                   else
                                     {
                                      document.getElementById('green').innerHTML                           =  '<span>'+'#{stock}'+'</span>' ;
                                      document.getElementById('red').innerHTML                             =  '' ;
                                     }


                                </script>"
    end

    def get_moeda                 #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                                  document.getElementById('producao_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                </script>"
    end

    def busca                     #
        @producaos = Producao.filtro(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end
   
    def index
      render layout: 'chart'
    end

    def show
      @producao = Producao.find(params[:id])
      render layout: 'chart'
    end

    def detalhe_print             #
        @producao = Producao.find(params[:id])
        @producao_produtos = ProducaoProduto.all(:conditions => ['producao_id = ?',@producao.id])

        head =
        "                                                                               #{$empresa_nome}
                                                                                    Resumen De la Producion

Abierto : #{@producao.data.strftime("%d/%m/%Y")}  Cerrado en  #{@producao.data_finalizacao.strftime("%d/%m/%Y")}

        "


            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')

            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Modulo_de_Producion.pdf")
    end

    def new                       #
        @producao = Producao.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @producao }
        end
    end

    def edit                      #
        @producao = Producao.find(params[:id])
        session[:pagina] = '0'
    end

    def producao_final            #
        @producao = Producao.find(params[:id])
        session[:pagina] = '2'
    end

    def create                    #
        @producao = Producao.new(params[:producao])

        @producao.usuario_created = current_user.usuario_nome
        @producao.unidade_created = current_unidade.unidade_nome

        respond_to do |format|
            if @producao.save
                format.html { redirect_to(@producao, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                    #
        @producao = Producao.find(params[:id])

        @producao.usuario_updated = current_user.usuario_nome
        @producao.unidade_updated = current_unidade.unidade_nome

        respond_to do |format|
            if @producao.update_attributes(params[:producao])
                if session[:pagina] == '0'
                    format.html { redirect_to(@producao, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
                else
                    format.html { redirect_to producao_final_producao_path(@producao) }
                end
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                   #
        @producao = Producao.find(params[:id])
        @producao.destroy

        respond_to do |format|
            format.html { redirect_to(producaos_url) }
        end
    end
end

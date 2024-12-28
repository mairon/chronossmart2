class ManutencaoMaquinasController < ApplicationController
    before_filter :authenticate


    def detalhe_print             #
        @manutencao_maquina = ManutencaoMaquina.find(params[:id])
        @producao_produtos = ManutencaoMaquinaProduto.all(:conditions => ['manutencao_maquina_id = ?',@manutencao_maquinas.id])

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
    def get_codigo_barra_produto  #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:codigo]])

        stock = Stock.sum( 'entrada - saida',:conditions => ['produto_id = ?',@produto.id] )

        return render :text => "<script type='text/javascript'>
                                  document.getElementById('manutencao_maquina_produto_produto_id').value             = '#{@produto.id.to_i}';
                                  document.getElementById('manutencao_maquina_produto_produto_nome').value           = '#{@produto.nome.to_s}';
                                  document.getElementById('manutencao_maquina_produto_clase_id').value               = '#{@produto.clase_id.to_i}';
                                  document.getElementById('manutencao_maquina_produto_grupo_id').value               = '#{@produto.grupo_id.to_i}';
                                  document.getElementById('manutencao_maquina_produto_sub_grupo_id').value           = '#{@produto.sub_grupo_id.to_i}';
                                  document.getElementById('manutencao_maquina_produto_unitario_dolar').value         =  number_format( #{@produto.preco_venda_dolar},2, ',', '.')
                                  document.getElementById('manutencao_maquina_produto_unitario_guarani').value       = number_format( #{@produto.preco_venda_guarani},0, ',', '.');

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


    def get_codigo  #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:codigo]])

        return render :text => "<script type='text/javascript'>
                                  document.getElementById('manutencao_maquina_produto_id').value             = '#{@produto.id.to_i}';
                                </script>"
    end


    def manutencao_final          #
        @manutencao_maquina = ManutencaoMaquina.find(params[:id])
    end

    def get_moeda                 #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                                  document.getElementById('manutencao_maquina_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                </script>"
    end

    def index                     #
        @manutencao_maquinas = ManutencaoMaquina.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @manutencao_maquinas }
        end
    end

    def show                      #
        @manutencao_maquina = ManutencaoMaquina.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @manutencao_maquina }
        end
    end

    def new                       #
        @manutencao_maquina = ManutencaoMaquina.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @manutencao_maquina }
        end
    end

    def edit                      #
        @manutencao_maquina = ManutencaoMaquina.find(params[:id])
    end

    def create                    #
        @manutencao_maquina = ManutencaoMaquina.new(params[:manutencao_maquina])

        respond_to do |format|
            if @manutencao_maquina.save
                format.html { redirect_to(@manutencao_maquina, :notice => 'ManutencaoMaquina was successfully created.') }
                format.xml  { render :xml => @manutencao_maquina, :status => :created, :location => @manutencao_maquina }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @manutencao_maquina.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update                    #
        @manutencao_maquina = ManutencaoMaquina.find(params[:id])

        respond_to do |format|
            if @manutencao_maquina.update_attributes(params[:manutencao_maquina])
                format.html { redirect_to(@manutencao_maquina, :notice => 'ManutencaoMaquina was successfully updated.') }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @manutencao_maquina.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy                   #
        @manutencao_maquina = ManutencaoMaquina.find(params[:id])
        @manutencao_maquina.destroy

        respond_to do |format|
            format.html { redirect_to(manutencao_maquinas_url) }
            format.xml  { head :ok }
        end
    end
end

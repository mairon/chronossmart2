class ManutencaoMaquinaProdutosController < ApplicationController

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

    def index               #
        @manutencao_maquina_produtos = ManutencaoMaquinaProduto.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @manutencao_maquina_produtos }
        end
    end

    def show                #
        @manutencao_maquina_produto = ManutencaoMaquinaProduto.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @manutencao_maquina_produto }
        end
    end

    def new                 #
        @manutencao_maquina = ManutencaoMaquina.find(params[:manutencao_maquina_id])

        @manutencao_maquina_produto = ManutencaoMaquinaProduto.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @manutencao_maquina_produto }
        end
    end

    def edit                #
        @manutencao_maquina = ManutencaoMaquina.find(params[:manutencao_maquina_id])

        @manutencao_maquina_produto = ManutencaoMaquinaProduto.find(params[:id])
    end

    def create              #
        @manutencao_maquina = ManutencaoMaquina.find(params[:manutencao_maquina_id])

        @manutencao_maquina_produto = @manutencao_maquina.manutencao_maquina_produtos.build(params[:manutencao_maquina_produto])

        respond_to do |format|
            if @manutencao_maquina_produto.save
                format.html { redirect_to manutencao_maquina_path(@manutencao_maquina) }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update              #
        @manutencao_maquina = ManutencaoMaquina.find(params[:manutencao_maquina_id])
        @manutencao_maquina_produto = ManutencaoMaquinaProduto.find(params[:id])

        respond_to do |format|
            if @manutencao_maquina_produto.update_attributes(params[:manutencao_maquina_produto])
                format.html { redirect_to manutencao_maquina_path(@manutencao_maquina) }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy             #
        @manutencao_maquina = ManutencaoMaquina.find(params[:manutencao_maquina_id])
        @manutencao_maquina_produto = ManutencaoMaquinaProduto.find(params[:id])
        @manutencao_maquina_produto.destroy

        respond_to do |format|
            format.html { redirect_to manutencao_maquina_path(@manutencao_maquina) }
        end
    end
end

class RecepcaoNotaRemicaosController < ApplicationController
    before_filter :authenticate

    def get_unidade_cod         #

        @unidade =  Unidade.find(:first, :conditions =>  [ "id = ?", params[:recepcao_nota_remicao_destino_unidade_id]])

        return render :text => "<script type='text/javascript'>
                                          document.getElementById('recepcao_nota_remicao_destino_unidade_nome').value     = '#{@unidade.unidade_nome.to_s}';
                                          document.getElementById('recepcao_nota_remicao_direcao').value                  = '#{@unidade.direcao.to_s}';
                                          document.getElementById('recepcao_nota_remicao_bairro').value                   = '#{@unidade.bairro.to_s}';
                                          document.getElementById('recepcao_nota_remicao_cidade_id').value                = '#{@unidade.cidade_id.to_i}';
                                        </script>"
    end

    def get_persona_cod         #

        @persona =  Persona.find(:first, :conditions =>  [ "cod_velho = ?", params[:recepcao_nota_remicao_destino_persona_cod]])

        return render :text => "<script type='text/javascript'>
                                                      document.getElementById('recepcao_nota_remicao_destino_persona_id').value       = '#{@persona.id.to_i}';
                                                      document.getElementById('recepcao_nota_remicao_direcao').value                  = '#{@persona.direcao.to_s}';
                                                      document.getElementById('recepcao_nota_remicao_bairro').value                   = '#{@persona.bairro.to_s}';
                                                      document.getElementById('recepcao_nota_remicao_cidade_id').value                = '#{@persona.cidade_id.to_i}';
                                              </script>"
    end

    def get_produto_cod         #

        @produto            =  Produto.find(:first, :conditions =>  [ "cod_velho = ?", params[:recepcao_nota_remicao_produto_produto_cod]])

        @stock               = Stock.sum( 'entrada - saida',:conditions => ['produto_id = ?',@produto.id] )
        @ultimo_custo        = Stock.find(:last,:conditions => ['status = 0 and produto_id = ?',@produto.id])
        return render :text => "<script type='text/javascript'>
                                                      document.getElementById('recepcao_nota_remicao_produto_produto_nome').value       = '#{@produto.nome.to_s}';
                                                      document.getElementById('recepcao_nota_remicao_produto_produto_id').value         = '#{@produto.id.to_i}';
                                                      document.getElementById('recepcao_nota_remicao_produto_clase_id').value           = '#{@produto.clase_id.to_i}';
                                                      document.getElementById('recepcao_nota_remicao_produto_grupo_id').value           = '#{@produto.grupo_id.to_i}';
                                                      document.getElementById('recepcao_nota_remicao_produto_saldo').value              = '#{@stock}';
                                                      ;
                                              </script>"
    end

    def detalhes_produtos_print #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.find(params[:id])

        @nota_produtos = RecepcaoNotaRemicaoProduto.all(:conditions => ["recepcao_nota_remicao_id = #{params[:id]}"])
        @qtd           = RecepcaoNotaRemicaoProduto.sum(:quantidade,:conditions => ["recepcao_nota_remicao_id = #{params[:id]}"])

        render :layout => false
    end

    def comprovante             #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.find(params[:id])

        @nota_produtos = RecepcaoNotaRemicaoProduto.all(:conditions => ["recepcao_nota_remicao_id = #{params[:id]}"])
        @qtd           = RecepcaoNotaRemicaoProduto.sum(:quantidade,:conditions => ["recepcao_nota_remicao_id = #{params[:id]}"])
        @custo_guarani = RecepcaoNotaRemicaoProduto.sum(:custo_guarani,:conditions => ["recepcao_nota_remicao_id = #{params[:id]}"])
        @valor_guarani = RecepcaoNotaRemicaoProduto.sum(:valor_guarani,:conditions => ["recepcao_nota_remicao_id = #{params[:id]}"])

        render :layout => false
    end

    def index                   #
        @recepcao_nota_remicaos = RecepcaoNotaRemicao.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @recepcao_nota_remicaos }
        end
    end

    def show                    #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @recepcao_nota_remicao }
        end
    end

    def new                     #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @recepcao_nota_remicao }
        end
    end

    def edit                    #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.find(params[:id])
    end

    def create                  #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.new(params[:recepcao_nota_remicao])

        respond_to do |format|
            if @recepcao_nota_remicao.save
                format.html { redirect_to(@recepcao_nota_remicao, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
                format.xml  { render :xml => @recepcao_nota_remicao, :status => :created, :location => @recepcao_nota_remicao }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @recepcao_nota_remicao.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update                  #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.find(params[:id])


        respond_to do |format|
            if @recepcao_nota_remicao.update_attributes(params[:recepcao_nota_remicao])
                format.html { redirect_to(@recepcao_nota_remicao, :notice => t('SUCESSFUL_EDIT_MESSAGE')) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @recepcao_nota_remicao.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy                 #
        @recepcao_nota_remicao = RecepcaoNotaRemicao.find(params[:id])
        @recepcao_nota_remicao.destroy

        respond_to do |format|
            format.html { redirect_to(recepcao_nota_remicaos_url) }
            format.xml  { head :ok }
        end
    end

end

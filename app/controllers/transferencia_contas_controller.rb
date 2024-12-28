
class TransferenciaContasController < ApplicationController
    before_filter :authenticate

    def busca_diferido
      @transferencia_conta = TransferenciaConta.find(params[:id])
      periodo = "DIFERIDO BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' 
              AND " unless params[:final].blank?
      sql = "SELECT 
                   CHEQUE,
                   MAX(COD_PROC) AS COD_PROC,
                   MAX(SIGLA_PROC) AS SIGLA_PROC,
                   MAX(DATA) AS DATA,
                   MAX(DIFERIDO) AS DIFERIDO,
                   MAX(TITULAR) AS TITULAR,
                   MAX(BANCO) AS BANCO,
                   MAX(PERSONA_NOME) AS PERSONA_NOME,
                   MAX(CONTA_NOME) AS CONTA_NOME,
                   SUM(ENTRADA_DOLAR) AS ENTRADA_DOLAR,
                   SUM(ENTRADA_GUARANI) AS ENTRADA_GUARANI,
                   MAX(ID) AS ID
            FROM FINANCAS
            WHERE #{periodo}(CONTA_ID = #{params[:conta_id]} AND MOEDA = #{params[:moeda]} AND CHEQUE_STATUS IN (1,3))
            GROUP BY 1
            ORDER BY 5,4

"

        @diferido = Financa.find_by_sql(sql)
        render :layout => 'consulta'
    end

    def resultado_busca_diferido   #
        @transferencia_conta = TransferenciaConta.find(params[:id])

        @diferido  = Financa.find(params[:diferido_ids])
        TransferenciaContasDetalhe.destroy_all("transferencia_conta_id = #{params[:id]} AND cheque_status = 1 " )
        @diferido.each do |df|
          if @transferencia_conta.deposito == 2
            if @transferencia_conta.destino_moeda == 0 && @transferencia_conta.ingreso_moeda == 1

               TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                  :original                => df.data,
                  :diferido                => df.diferido,
                  :data                    => @transferencia_conta.data,
                  :moeda                   => df.moeda,
                  :status                  => 0,
                  :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                  :destino_moeda           => @transferencia_conta.destino_moeda,
                  :deposito                => @transferencia_conta.deposito,
                  :conta_origem_id         => @transferencia_conta.ingreso_id,
                  :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                  :conta_destino_id        => @transferencia_conta.destino_id,
                  :conta_destino_nome      => @transferencia_conta.destino_nome,
                  :persona_id              => df.persona_id,
                  :persona_nome            => df.persona_nome,
                  :cheque                  => df.cheque,
                  :banco                   => df.banco,
                  :titular                 => df.titular,
                  :concepto                => @transferencia_conta.concepto,
                  :cheque_status           => 1,
                  :entrada_dolar           => 0,
                  :entrada_guarani         => 0,  
                  :entrada_real            => 0,  
                  :saida_dolar             => df.entrada_guarani / @transferencia_conta.cotacao.to_f ,
                  :saida_guarani           => df.entrada_guarani.to_f,
                  :saida_real              => df.entrada_guarani.to_f / @transferencia_conta.cotacao_real.to_f ,
                  :tabela_id               => df.id,
                  :tabela                  => 'CHEQUES DIFERIDOS' )
            elsif @transferencia_conta.destino_moeda == 1 && @transferencia_conta.ingreso_moeda == 0

               TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                  :original                => df.data,
                  :diferido                => df.diferido,
                  :data                    => @transferencia_conta.data,
                  :moeda                   => df.moeda,
                  :status                  => 0,
                  :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                  :destino_moeda           => @transferencia_conta.destino_moeda,
                  :deposito                => @transferencia_conta.deposito,
                  :conta_origem_id         => @transferencia_conta.ingreso_id,
                  :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                  :conta_destino_id        => @transferencia_conta.destino_id,
                  :conta_destino_nome      => @transferencia_conta.destino_nome,
                  :persona_id              => df.persona_id,
                  :persona_nome            => df.persona_nome,
                  :cheque                  => df.cheque,
                  :banco                   => df.banco,
                  :titular                 => df.titular,
                  :concepto                => @transferencia_conta.concepto,
                  :cheque_status           => 1,
                  :entrada_dolar           => 0,
                  :entrada_guarani         => 0,
                  :entrada_real            => 0,
                  :saida_dolar             => df.entrada_dolar.to_f,
                  :saida_guarani           => df.entrada_dolar * @transferencia_conta.cotacao.to_f,
                  :saida_real              => df.entrada_guarani / @transferencia_conta.cotacao_real.to_f,
                  :tabela_id               => df.id,
                  :tabela                  => 'CHEQUES DIFERIDOS' )

            elsif @transferencia_conta.destino_moeda == 2 && @transferencia_conta.ingreso_moeda == 0


              TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                  :original                => df.data,
                  :diferido                => df.diferido,
                  :data                    => @transferencia_conta.data,
                  :moeda                   => df.moeda,
                  :status                  => 0,
                  :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                  :destino_moeda           => @transferencia_conta.destino_moeda,
                  :deposito                => @transferencia_conta.deposito,
                  :conta_origem_id         => @transferencia_conta.ingreso_id,
                  :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                  :conta_destino_id        => @transferencia_conta.destino_id,
                  :conta_destino_nome      => @transferencia_conta.destino_nome,
                  :persona_id              => df.persona_id,
                  :persona_nome            => df.persona_nome,
                  :cheque                  => df.cheque,
                  :banco                   => df.banco,
                  :titular                 => df.titular,
                  :concepto                => @transferencia_conta.concepto,
                  :cheque_status           => 1,
                  :entrada_dolar           => 0,
                  :entrada_guarani         => 0,
                  :entrada_real            => 0,
                  :saida_dolar             => df.entrada_dolar.to_f,
                  :saida_guarani           => df.entrada_dolar.to_f * @transferencia_conta.cotacao.to_i,
                  :saida_real              => (df.entrada_dolar.to_f * @transferencia_conta.cotacao.to_i) / @transferencia_conta.cotacao_real.to_i,
                  :tabela_id               => df.id,
                  :tabela                  => 'CHEQUES DIFERIDOS' )



            else
               TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                  :original                => df.data,
                  :diferido                => df.diferido,
                  :data                    => @transferencia_conta.data,
                  :moeda                   => df.moeda,
                  :status                  => 0,
                  :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                  :destino_moeda           => @transferencia_conta.destino_moeda,
                  :deposito                => @transferencia_conta.deposito,
                  :conta_origem_id         => @transferencia_conta.ingreso_id,
                  :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                  :conta_destino_id        => @transferencia_conta.destino_id,
                  :conta_destino_nome      => @transferencia_conta.destino_nome,
                  :persona_id              => df.persona_id,
                  :persona_nome            => df.persona_nome,
                  :cheque                  => df.cheque,
                  :banco                   => df.banco,
                  :titular                 => df.titular,
                  :concepto                => @transferencia_conta.concepto,
                  :cheque_status           => 1,
                  :entrada_dolar           => 0,
                  :entrada_guarani         => 0,
                  :entrada_real            => 0,
                  :saida_dolar             => df.entrada_dolar.to_f,
                  :saida_guarani           => df.entrada_guarani.to_f,
                  :saida_real              => df.entrada_real.to_f,
                  :tabela_id               => df.id,
                  :tabela                  => 'CHEQUES DIFERIDOS' )
            end
          else
          if @transferencia_conta.destino_moeda == 0 && @transferencia_conta.ingreso_moeda == 1
            TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                :original                => df.data,
                :diferido                => df.diferido,
                :data                    => @transferencia_conta.data,
                :moeda                   => df.moeda,
                :status                  => 1,
                :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                :destino_moeda           => @transferencia_conta.destino_moeda,
                :deposito                => @transferencia_conta.deposito,
                :conta_origem_id         => @transferencia_conta.ingreso_id,
                :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                :conta_destino_id        => @transferencia_conta.destino_id,
                :conta_destino_nome      => @transferencia_conta.destino_nome,
                :persona_id              => df.persona_id,
                :persona_nome            => df.persona_nome,
                :cheque                  => df.cheque,
                :banco                   => df.banco,
                :titular                 => df.titular,
                :concepto                => @transferencia_conta.concepto,
                :cheque_status           => df.cheque_status,
                :entrada_dolar           => 0,
                :entrada_guarani         => 0,
                :entrada_real            => 0,
                :saida_dolar             => df.entrada_guarani / @transferencia_conta.cotacao.to_f,
                :saida_guarani           => df.entrada_guarani,
                :saida_real              => df.entrada_real,
                :tabela_id               => df.id,
                :tabela                  => 'CHEQUES DIFERIDOS' )
            elsif @transferencia_conta.destino_moeda == 1 && @transferencia_conta.ingreso_moeda == 0
            TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                :original                => df.data,
                :diferido                => df.diferido,
                :data                    => @transferencia_conta.data,
                :moeda                   => df.moeda,
                :status                  => 1,
                :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                :destino_moeda           => @transferencia_conta.destino_moeda,
                :deposito                => @transferencia_conta.deposito,
                :conta_origem_id         => @transferencia_conta.ingreso_id,
                :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                :conta_destino_id        => @transferencia_conta.destino_id,
                :conta_destino_nome      => @transferencia_conta.destino_nome,
                :persona_id              => df.persona_id,
                :persona_nome            => df.persona_nome,
                :cheque                  => df.cheque,
                :banco                   => df.banco,
                :titular                 => df.titular,
                :concepto                => @transferencia_conta.concepto,
                :cheque_status           => df.cheque_status,
                :entrada_dolar           => 0,
                :entrada_guarani         => 0,
                :entrada_real            => 0,
                :saida_dolar             => df.entrada_dolar,
                :saida_guarani           => df.entrada_dolar * @transferencia_conta.cotacao.to_f,
                :saida_real              => df.entrada_real,
                :tabela_id               => df.id,
                :tabela                  => 'CHEQUES DIFERIDOS' )

            elsif @transferencia_conta.destino_moeda == 1 && @transferencia_conta.ingreso_moeda == 1
            TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                :original                => df.data,
                :diferido                => df.diferido,
                :data                    => @transferencia_conta.data,
                :moeda                   => df.moeda,
                :status                  => 1,
                :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                :destino_moeda           => @transferencia_conta.destino_moeda,
                :deposito                => @transferencia_conta.deposito,
                :conta_origem_id         => @transferencia_conta.ingreso_id,
                :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                :conta_destino_id        => @transferencia_conta.destino_id,
                :conta_destino_nome      => @transferencia_conta.destino_nome,
                :persona_id              => df.persona_id,
                :persona_nome            => df.persona_nome,
                :cheque                  => df.cheque,
                :banco                   => df.banco,
                :titular                 => df.titular,
                :concepto                => @transferencia_conta.concepto,
                :cheque_status           => df.cheque_status,
                :entrada_dolar           => 0,
                :entrada_guarani         => 0,
                :entrada_real            => 0,
                :saida_dolar             => df.entrada_dolar,
                :saida_guarani           => df.entrada_guarani,
                :saida_real              => df.entrada_real,
                :tabela_id               => df.id,
                :tabela                  => 'CHEQUES DIFERIDOS' )

            elsif @transferencia_conta.destino_moeda == 0 && @transferencia_conta.ingreso_moeda == 0
            TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                :original                => df.data,
                :diferido                => df.diferido,
                :data                    => @transferencia_conta.data,
                :moeda                   => df.moeda,
                :status                  => 1,
                :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                :destino_moeda           => @transferencia_conta.destino_moeda,
                :deposito                => @transferencia_conta.deposito,
                :conta_origem_id         => @transferencia_conta.ingreso_id,
                :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                :conta_destino_id        => @transferencia_conta.destino_id,
                :conta_destino_nome      => @transferencia_conta.destino_nome,
                :persona_id              => df.persona_id,
                :persona_nome            => df.persona_nome,
                :cheque                  => df.cheque,
                :banco                   => df.banco,
                :titular                 => df.titular,
                :concepto                => @transferencia_conta.concepto,
                :cheque_status           => df.cheque_status,
                :entrada_dolar           => 0,
                :entrada_guarani         => 0,
                :entrada_real            => 0,
                :saida_dolar             => df.entrada_dolar,
                :saida_guarani           => df.entrada_guarani,
                :saida_real              => df.entrada_real,
                :tabela_id               => df.id,
                :tabela                  => 'CHEQUES DIFERIDOS' )
            end
        end
       end 
        
        redirect_to(@transferencia_conta)
        
    end

    def get_moeda                  #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('transferencia_conta_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('transferencia_conta_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def index                      #

        respond_to do |format|
            format.html # index.html.erb
        end
    end

    def busca
        params[:unidade] = current_unidade.id
        @transferencia_contas = TransferenciaConta.filtro(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end

    def show                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])

        @diferido            = TransferenciaContasDetalhe.all(:conditions => ["transferencia_conta_id = ?",@transferencia_conta.id])

        respond_to do |format|
            format.html # show.html.erb
        end
    end

    def comprovante                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])
         
        @diferido            = TransferenciaContasDetalhe.all(:conditions => ["transferencia_conta_id = ?",@transferencia_conta.id])
        
        render :layout => false
    end

    def viatico                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])
         
        @diferido            = TransferenciaContasDetalhe.all(:conditions => ["transferencia_conta_id = ?",@transferencia_conta.id])
        
        render :layout => false
    end


    def new                        #
        @transferencia_conta = TransferenciaConta.new        
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @transferencia_conta }
        end
    end

    def edit                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])
    end

    def create

        @transferencia_conta = TransferenciaConta.new(params[:transferencia_conta])
        @transferencia_conta.usuario_created = current_user.id
        @transferencia_conta.unidade_created = current_unidade.id
        @transferencia_conta.unidade_id = current_unidade.id

        respond_to do |format|
            if @transferencia_conta.save
                format.html { redirect_to(@transferencia_conta) }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                     #
        @transferencia_conta = TransferenciaConta.find(params[:id])

        @transferencia_conta.usuario_updated = current_user.id
        @transferencia_conta.unidade_updated = current_unidade.id

        respond_to do |format|
            if @transferencia_conta.update_attributes(params[:transferencia_conta])
                format.html { redirect_to(@transferencia_conta) }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                    #
    
    @transferencia_conta = TransferenciaConta.find(params[:id])


    @transferencia_conta.destroy

      respond_to do |format|
                format.html { redirect_to(transferencia_contas_url) }
        format.xml  { head :ok }
      end
    end
end

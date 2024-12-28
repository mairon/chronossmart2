class PagosFinancasController < ApplicationController
      before_filter :authenticate

      def index             #
        @pagos_financas = PagosFinanca.all

        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @pagos_financas }
        end
      end

      def show              #
        @pagos_financa = PagosFinanca.find(params[:id])

        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @pagos_financa }
        end
      end

      def new               #
        @pagos_financa = PagosFinanca.new

        respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @pagos_financa }
        end
      end

      def edit              #
        @pagos_financa = PagosFinanca.find(params[:id])
      end

      def create            #
        @pagos_financa = PagosFinanca.new(params[:pagos_financa])
        @pagos_financa.usuario_created = current_user.id
        @pagos_financa.unidade_created = current_unidade.id

        respond_to do |format|
          if @pagos_financa.save
            if @pagos_financa.pago.proveedore_id.to_i > 0
              format.html { redirect_to "/pagos/#{@pagos_financa.pago_id}/financa_painel_pagar" }
            else
              format.html { redirect_to "/pagos/#{@pagos_financa.pago_id}/pago_final" }
            end

            format.html { redirect_to "/pagos/#{@pagos_financa.pago_id}/pago_final" }
            format.xml  { render :xml => @pagos_financa, :status => :created, :location => @pagos_financa }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @pagos_financa.errors, :status => :unprocessable_entity }
          end
        end
      end

      def update            #
        @pagos_financa = PagosFinanca.find(params[:id])
        @pagos_financa.usuario_updated = current_user.id
        @pagos_financa.unidade_updated = current_unidade.id

        respond_to do |format|
          if @pagos_financa.update_attributes(params[:pagos_financa])
            if @pagos_financa.pago.proveedore_id.to_i > 0
              format.html { redirect_to "/pagos/#{@pagos_financa.pago_id}/financa_painel_pagar" }
            else
              format.html { redirect_to "/pagos/#{@pagos_financa.pago_id}/pago_final" }
            end

            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @pagos_financa.errors, :status => :unprocessable_entity }
          end
        end
      end

      def destroy           #
        @pagos_financa = PagosFinanca.find(params[:id])
        @pagos_financa.destroy

        respond_to do |format|
          if @pagos_financa.pago.proveedore_id.to_i > 0
            format.html { redirect_to "/pagos/#{@pagos_financa.pago_id}/financa_painel_pagar" }
          else
            format.html { redirect_to "/pagos/#{@pagos_financa.pago_id}/pago_final" }
          end
        end
      end
end

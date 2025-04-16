class FinancasController < ApplicationController

	def resultado_recebimentos
		params[:unidade] = current_unidade.id
		@financas         = Financa.resultado_recebimentos(params)

		head =
"
																																						             #{current_unidade.nome_sys}
																																																							RECEBIMIENTOS
- Fecha...: #{params[:inicio]} hasta #{params[:final]}

-----------------------------------------------------------------------------------------------------------------------------------------
		 Cod.    Fecha   Cliente                           Forma de Pago           Moneda            U$       Gs.       R$.
-----------------------------------------------------------------------------------------------------------------------------------------

"

		respond_to do |format|
			format.html do
				render  :pdf                    => "relatorio_financas",
								:layout                 => "layer_relatorios",
								 :formats => [:html],
								:user_style_sheet       => '/assets/relatorios.css',
								:show_as_html           => params[:debug].present?,
								:margin => {:top        => '1.10in',
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
														:left       => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
	end

	def calcula_valores_fluxo_caixa
		@receber = Cliente.where(moeda: params[:moeda]).sum('divida_guarani')
	end

	def update_individual
		Financa.update(params[:financas].keys, params[:financas].values)
		redirect_to(:back)
		flash[:notice] = "Datos Conciliados!"

	end

	def resultado_extrato_tarjeta
		@financas         = Financa.resultado_extrato_tarjeta(params)
		@financas_anterior = Financa.relatorio_financas_saldo_anterior(params)

		if params[:moeda] == '0'
			moeda = 'Dolar'
		elsif params[:moeda] == '1'
			moeda = 'Guaranies'
		else
			moeda = 'Reais'
		end
		conta = Conta.find_by_id(params[:busca]["conta"])
		head =
"                                                   #{$empresa_nome}
																															EXTRACTO TARJETA
- Fecha...: #{params[:inicio]} hasta #{params[:final]}
- Cuenta..: #{conta.nome}
- Moneda..: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
		Fecha    Concepto                                                                         N. Compro.      Credito  Debito      Saldo
-----------------------------------------------------------------------------------------------------------------------------------------

"

		respond_to do |format|
			format.html do
				render  :pdf                    => "relatorio_financas",
								:layout                 => "layer_relatorios",
								 :formats => [:html],
								:user_style_sheet       => '/assets/relatorios.css',
								:show_as_html           => params[:debug].present?,
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
														:left       => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
	end


	def resultado_pagamentos
		params[:unidade] = current_unidade.id

		@financas         = Financa.resultado_pagamentos(params)
        respond_to do |format|
		      if params[:tipo] == '1'

		        format.html {
		          render :xlsx => "resultado_pagamentos", 
		          filename: "resultado_pagamentos-#{params[:inicio]}-#{params[:final]}"
		        } 
           else
            format.html do
              	render :layout => 'relatorio_view'
              end
            end
        end
    end

	def relatorio_financas

		@financas         = Financa.relatorio_financas(params)
		@financas_anterior = Financa.relatorio_financas_saldo_anterior(params)

		if params[:moeda] == '0'
			moeda = 'Dolar'
		elsif params[:moeda] == '1'
			moeda = 'Guaranies'
		else
			moeda = 'Reais'
		end
		conta = Conta.find_by_id(params[:busca]["conta"])
		head =
"                                                   #{$empresa_nome}
																															EXTRACTO CAJA
- Fecha...: #{params[:inicio]} hasta #{params[:final]}
- Cuenta..: #{conta.nome}
- Moneda..: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
		Fecha    Concepto                                                                    N. Cheque       Credito      Debito       Saldo
-----------------------------------------------------------------------------------------------------------------------------------------

"

        respond_to do |format|
		      if params[:tipo] == '1'
		        format.html {
		          xls = render_to_string :action => "relatorio_financas", :layout => false
		          kit = PDFKit.new(xls,
		                           :encoding => 'UTF-8')
		          send_data(xls,:filename => "Financa-#{params[:inicio]}-#{params[:final]}.xls")
		        }
           else
            format.html do
              render  :pdf                    => "relatorio_financas",
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
                                  :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
              end
            end
        end
    end


	def index                       #
		respond_to do |format|
			format.html
			format.xml  { render :xml => @financas }
		end
	end

	def extrato_bancario            #
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @financas }
		end
	end

	def conciliacao_bancaria
		render layout: 'chart'
	end

	def resultado_conciliacao_bancaria
		@financas = Financa.relatorio_financas_conciliacao(params)
		render layout: 'chart'
	end


	def resultado_extrato_bancario

		@financas         = Financa.relatorio_financas(params)
		@financas_anterior = Financa.relatorio_financas_saldo_anterior(params)
		if params[:filtro] == '1'
			@lanz_futuros = Financa.lanz_futuros_extr_bc(params)
		end

		if params[:moeda] == '0'
			moeda = 'Dolar'
		elsif params[:moeda] == '1'
			moeda = 'Guaranies'
		else
			moeda = 'Reais'
		end

		if params[:tipo_data] == '0'
			tip = 'Registrado e no Conciliado'
		else
			tip = 'Registrados e Conciliado'
		end


		conta = Conta.find_by_id(params[:busca]["conta"])
		if params[:filtro] == '3'
			head = ""
		else

					head =
			"                                                          #{$empresa_nome}
																																EXTRACTO BANCARIO
			- Fecha.....: #{params[:inicio]} hasta #{params[:final]}
			- Cuenta....: #{conta.nome}
			- Moneda....: #{moeda}
			- Tipo......: #{tip}
			-----------------------------------------------------------------------------------------------------------------------------------------
				  Fecha     Nombre                  Concepto                                          Cheque      Credito        Debito         Saldo
			-----------------------------------------------------------------------------------------------------------------------------------------
			"
		end
        respond_to do |format|
		      if params[:tipo] == '1'
		        format.html {
		          xls = render_to_string :action => "resultado_extrato_bancario", :layout => false
		          kit = PDFKit.new(xls,
		                           :encoding => 'UTF-8')
		          send_data(xls,:filename => "Financa-#{params[:inicio]}-#{params[:final]}.xls")
		        }
           else
            format.html do
              render  :pdf                    => "resultado_extrato_bancario",
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
                                  :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
              end
            end
        end
    end

	def show                        #
		@financa = Financa.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @financa }
		end
	end


	def resultado_resumo_contas

		@financas_cajas = Financa.resumo_contas_cajas(params)
		@financas_bancos = Financa.resumo_contas_bancos(params)

		if params[:busca]["conta"] != ''
			conta = Conta.find_by_id(params[:busca]["conta"])
			c = conta.nome
		else
			c = 'Todos...'
		end
		head =
"                                                        #{$empresa_nome}
																											RESUMEN DE CONTAS
- Fecha...: #{params[:inicio]} hasta #{params[:final]}
- Cuenta..: #{c}
-----------------------------------------------------------------------------------------------------------------------------------------
Cuentas                                Anterior         Entrada        Salida          Saldo
-----------------------------------------------------------------------------------------------------------------------------------------

"

		respond_to do |format|
			format.html do
				render  :pdf                    => "relatorio_financas",
								:layout                 => "layer_relatorios",
								 :formats => [:html],
								:user_style_sheet       => '/assets/relatorios.css',
								:show_as_html           => params[:debug].present?,
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
														:left       => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
	end

  def create
    @financa = Financa.new(params[:financa])
    respond_to do |format|
      if @financa.save
        if @financa.tabela == 'VIATICO_DEV'
        	format.html { redirect_to(:back) }
      	else
      		format.html { redirect_to(painel_financas_path(persona_id: @financa.persona_id)) }
        end
      else
        format.html { render :action => "new" }
      end
  	end
  end


  def destroy
    @financa = Financa.find(params[:id])
    @financa.destroy

    respond_to do |format|
      if @financa.tabela == 'VIATICO_DEV'
        format.html { redirect_to(:back) }
      end
    end
  end
end

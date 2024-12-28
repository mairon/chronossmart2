class MenusController < ApplicationController
	def dt_autorizacao
		if params[:proc] == 'VT'
			@venda = Venda.find_by_id(params[:id])
		elsif params[:proc] == 'CB'
			@cobro = Cobro.find_by_id(params[:id])
		elsif params[:proc] == 'CBP'
			@nota_credito = NotaCredito.find_by_id(params[:id])
		end

		render layout: 'consulta'
	end

	def show
	end
	
	def autoriza_doc
		@ft = FormFiscal.find_by_id(params[:id])
    @ft.update_attribute :autorizacao, true
    redirect_to menus_url
	end

	def index


		if params[:data].blank?
			@data = Time.now.strftime("%m")
		else
			@data = params[:data]
		end

	   	@aniversarios = Persona.all( :select => "id,nome,email,telefone,observacao, data_nascimento",
                               :conditions => ["estado = 0 and date_part('month', data_nascimento) = '#{@data}' "],
                                 :order => "date_part('day', data_nascimento)" )
			@aniversario_contatos = PersonaContato.all( :select => "id,nome, persona_id, data_nascimento",
                               :conditions => ["date_part('month', data_nascimento) = '#{@data}' "],
                                 :order => "date_part('day', data_nascimento)" )


		if current_user.dash_finac == true
			#A Receber
			@saldo_receber_hoje_us = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 0 and clientes.vencimento = ?", Time.now.to_date ).sum('clientes.divida_dolar - clientes.cobro_dolar')
			@saldo_receber_hoje_gs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 1 and clientes.vencimento = ?", Time.now.to_date ).sum('clientes.divida_guarani - clientes.cobro_guarani')
			@saldo_receber_hoje_rs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 2 and clientes.vencimento = ?", Time.now.to_date ).sum('clientes.divida_real - clientes.cobro_real')

			@saldo_receber_atraso_us = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 0 and clientes.vencimento < ?", Time.now.to_date ).sum('clientes.divida_dolar - clientes.cobro_dolar')
			@saldo_receber_atraso_gs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 1 and clientes.vencimento < ?", Time.now.to_date ).sum('clientes.divida_guarani - clientes.cobro_guarani')
			@saldo_receber_atraso_rs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 2 and clientes.vencimento < ?", Time.now.to_date ).sum('clientes.divida_real - clientes.cobro_real')


			@saldo_receber_mes_us = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1 
					      and clientes.liquidacao = 0 
					      and clientes.unidade_id = #{current_unidade.id}
					      and clientes.moeda = 0 
					      and clientes.vencimento BETWEEN '#{ (Date.today.to_date + 1).strftime('%Y-%m-%d') }' AND '#{Date.today.end_of_month}'" )
				.sum('clientes.divida_dolar - clientes.cobro_dolar')

			@saldo_receber_mes_gs = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1 
					      and clientes.liquidacao = 0 
					      and clientes.moeda = 1
					      and clientes.unidade_id = #{current_unidade.id}
					      and clientes.vencimento BETWEEN '#{ (Date.today.to_date + 1).strftime('%Y-%m-%d') }' AND '#{Date.today.end_of_month}'" )
				.sum('clientes.divida_guarani - clientes.cobro_guarani')


			@saldo_receber_mes_rs = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1
					      and clientes.liquidacao = 0
					      and clientes.moeda = 2
					      and clientes.unidade_id = #{current_unidade.id}
					      and clientes.vencimento BETWEEN '#{ (Date.today.to_date + 1).strftime('%Y-%m-%d') }' AND '#{Date.today.end_of_month}'" )
				.sum('clientes.divida_real - clientes.cobro_real')



			@saldo_receber_mes_total_us = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1
								and clientes.divida_dolar > 0
								and clientes.moeda = 0
								and clientes.unidade_id = #{current_unidade.id}
					      and date_part('month', clientes.vencimento) = ?
					      and date_part('year', clientes.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('clientes.divida_dolar')

			@saldo_recebido_mes_total_us = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1
								and clientes.moeda = 0
								and clientes.unidade_id = #{current_unidade.id}
					      and date_part('month', clientes.data) = ?
					      and date_part('year', clientes.data) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('clientes.cobro_dolar')


			@saldo_receber_mes_total_gs = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1
								and clientes.divida_guarani > 0
								and clientes.moeda = 1
								and clientes.unidade_id = #{current_unidade.id}
					      and date_part('month', clientes.vencimento) = ?
					      and date_part('year', clientes.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('clientes.divida_guarani')

			@saldo_recebido_mes_total_gs = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1
								and clientes.moeda = 1
								and clientes.unidade_id = #{current_unidade.id}
					      and date_part('month', clientes.data) = ?
					      and date_part('year', clientes.data) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('clientes.cobro_guarani')


			@saldo_receber_mes_total_rs = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1
								and clientes.divida_real > 0
								and clientes.moeda = 2
								and clientes.unidade_id = #{current_unidade.id}
					      and date_part('month', clientes.vencimento) = ?
					      and date_part('year', clientes.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('clientes.divida_real')

			@saldo_recebido_mes_total_rs = Cliente.joins(:persona)
				.where("personas.tipo_cliente = 1
								and clientes.moeda = 2
								and clientes.unidade_id = #{current_unidade.id}
					      and date_part('month', clientes.data) = ?
					      and date_part('year', clientes.data) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('clientes.cobro_real')

			@saldo_receber_vencido_us = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 0 and clientes.vencimento < ?", Time.now.to_date ).sum('clientes.divida_dolar - clientes.cobro_dolar')
			@saldo_receber_vencido_gs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and liquidacao = 0 and moeda = 1 and vencimento < ?", Time.now.to_date ).sum('clientes.divida_guarani - clientes.cobro_guarani')
			@saldo_receber_vencido_rs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and liquidacao = 0 and moeda = 2 and vencimento < ?", Time.now.to_date ).sum('clientes.divida_real - clientes.cobro_real')

			@saldo_receber_a_vencido_us = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 0 and clientes.vencimento >= ?", Time.now.to_date ).sum('clientes.divida_dolar - clientes.cobro_dolar')
			@saldo_receber_a_vencido_gs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 1 and clientes.vencimento >= ?", Time.now.to_date ).sum('clientes.divida_guarani - clientes.cobro_guarani')
			@saldo_receber_a_vencido_rs = Cliente.joins(:persona).where("clientes.unidade_id = #{current_unidade.id} and personas.tipo_cliente = 1 and clientes.liquidacao = 0 and clientes.moeda = 2 and clientes.vencimento >= ?", Time.now.to_date ).sum('clientes.divida_real - clientes.cobro_real')


			#A Pagar
			@saldo_pagar_hoje_us = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 0 and proveedores.vencimento = ?", Time.now.to_date ).sum('proveedores.divida_dolar - proveedores.pago_dolar')
			@saldo_pagar_hoje_gs = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 1 and proveedores.vencimento = ?", Time.now.to_date ).sum('proveedores.divida_guarani - proveedores.pago_guarani')
			@saldo_pagar_hoje_rs = Proveedore.joins(:persona).where("personas.tipo_fornecedor = 1 and proveedores.unidade_id = #{current_unidade.id} and proveedores.liquidacao = 0 and proveedores.moeda = 2 and proveedores.vencimento = ?", Time.now.to_date ).sum('proveedores.divida_real - proveedores.pago_real')

			@saldo_pagar_atraso_us = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 0 and proveedores.vencimento < ?", Time.now.to_date ).sum('proveedores.divida_dolar - proveedores.pago_dolar')
			@saldo_pagar_atraso_gs = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 1 and proveedores.vencimento < ?", Time.now.to_date ).sum('proveedores.divida_guarani - proveedores.pago_guarani')
			@saldo_pagar_atraso_rs = Proveedore.joins(:persona).where("personas.tipo_fornecedor = 1 and proveedores.unidade_id = #{current_unidade.id} and proveedores.liquidacao = 0 and proveedores.moeda = 2 and proveedores.vencimento < ?", Time.now.to_date ).sum('proveedores.divida_real - proveedores.pago_real')

			@saldo_pagar_mes_us = Proveedore.joins(:persona)
				.where("personas.tipo_fornecedor = 1 
					      and proveedores.liquidacao = 0 
					      and proveedores.moeda = 0 
					      
					      and proveedores.unidade_id = #{current_unidade.id}
					      and proveedores.vencimento BETWEEN '#{ (Date.today.to_date + 1).strftime('%Y-%m-%d') }' AND '#{Date.today.end_of_month}'")
				.sum('proveedores.divida_dolar - proveedores.pago_dolar')

			@saldo_pagar_mes_gs = Proveedore.joins(:persona)
				.where("personas.tipo_fornecedor = 1 
					      and proveedores.liquidacao = 0
					      and proveedores.unidade_id = #{current_unidade.id}
					      and proveedores.moeda = 1
					      and proveedores.vencimento BETWEEN '#{ (Date.today.to_date + 1).strftime('%Y-%m-%d') }' AND '#{Date.today.end_of_month}'" )
				.sum('proveedores.divida_guarani - proveedores.pago_guarani')

			@saldo_pagar_mes_rs = Proveedore.joins(:persona)
				.where("proveedores.liquidacao = 0
					      and proveedores.unidade_id = #{current_unidade.id}
					      and proveedores.moeda = 2
					      and personas.tipo_fornecedor = 1
					      and proveedores.vencimento BETWEEN '#{ (Date.today.to_date + 1).strftime('%Y-%m-%d') }' AND '#{Date.today.end_of_month}'")
				.sum('proveedores.divida_real - proveedores.pago_real')



			@saldo_a_pagar_mes_total_us = Proveedore.joins(:persona)
				.where("personas.tipo_funcionario = 0
								and proveedores.moeda = 0
								
								and proveedores.unidade_id = #{current_unidade.id}
					      and date_part('month', proveedores.vencimento) = ?
					      and date_part('year', proveedores.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('proveedores.divida_dolar')

			@saldo_a_pagar_mes_total_gs = Proveedore.joins(:persona)
				.where("personas.tipo_funcionario = 0
								and proveedores.moeda = 1
								
								and proveedores.unidade_id = #{current_unidade.id}
					      and date_part('month', proveedores.vencimento) = ?
					      and date_part('year', proveedores.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('proveedores.divida_guarani')

			@saldo_a_pagar_mes_total_rs = Proveedore.joins(:persona)
				.where("personas.tipo_funcionario = 0
								and proveedores.moeda = 2
								
								and proveedores.unidade_id = #{current_unidade.id}
					      and date_part('month', proveedores.vencimento) = ?
					      and date_part('year', proveedores.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('proveedores.divida_real')


			@saldo_pago_mes_total_us = Proveedore.joins(:persona)
				.where("personas.tipo_funcionario = 0
					and proveedores.moeda = 0
					
					and proveedores.unidade_id = #{current_unidade.id}
					      and date_part('month', proveedores.vencimento) = ?
					      and date_part('year', proveedores.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('proveedores.pago_dolar')

			@saldo_pago_mes_total_gs = Proveedore.joins(:persona)
				.where("personas.tipo_funcionario = 0
					and proveedores.moeda = 1
					
					and proveedores.unidade_id = #{current_unidade.id}
					      and date_part('month', proveedores.vencimento) = ?
					      and date_part('year', proveedores.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('proveedores.pago_guarani')

			@saldo_pago_mes_total_rs = Proveedore.joins(:persona)
				.where("personas.tipo_funcionario = 0
					and proveedores.moeda = 2
					
					and proveedores.unidade_id = #{current_unidade.id}
					      and date_part('month', proveedores.vencimento) = ?
					      and date_part('year', proveedores.vencimento) = ?",
					      Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
				.sum('proveedores.pago_real')

			@saldo_pagar_vencido_us = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 0 and proveedores.vencimento < ?", Time.now.to_date ).sum('proveedores.divida_dolar - proveedores.pago_dolar')
			@saldo_pagar_vencido_gs = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and liquidacao = 0 and moeda = 1 and vencimento < ?", Time.now.to_date ).sum('proveedores.divida_guarani - proveedores.pago_guarani')
			@saldo_pagar_vencido_rs = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and liquidacao = 0 and moeda = 2 and vencimento < ?", Time.now.to_date ).sum('proveedores.divida_real - proveedores.pago_real')

			@saldo_pagar_a_vencido_us = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 0 and proveedores.vencimento >= ?", Time.now.to_date ).sum('proveedores.divida_dolar - proveedores.pago_dolar')
			@saldo_pagar_a_vencido_gs = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 1 and proveedores.vencimento >= ?", Time.now.to_date ).sum('proveedores.divida_guarani - proveedores.pago_guarani')
			@saldo_pagar_a_vencido_rs = Proveedore.joins(:persona).where("proveedores.unidade_id = #{current_unidade.id} and personas.tipo_fornecedor = 1 and proveedores.liquidacao = 0 and proveedores.moeda = 2 and proveedores.vencimento >= ?", Time.now.to_date ).sum('proveedores.divida_real - proveedores.pago_real')

			#saldos financeiros

			@contas_cajas_us = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.forma_pago_id = 1 and contas.tipo = 0 and financas.moeda = 0").select('contas.nome as conta_nome, sum(financas.entrada_dolar - financas.saida_dolar) as saldo_us').group('contas.nome')
			@contas_bancos_us = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.forma_pago_id IN (1,15) and contas.tipo = 1 and financas.moeda = 0").select('contas.nome as conta_nome, sum(financas.entrada_dolar - financas.saida_dolar) as saldo_us').group('contas.nome')
			@contas_cheque_dif_us = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.forma_pago_id = 6 and contas.tipo = 0 and financas.moeda = 0").select('contas.nome as conta_nome, sum(financas.entrada_dolar - financas.saida_dolar) as saldo_us').group('contas.nome')

			@contas_cajas_gs = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.tipo = 0 and financas.moeda = 1").select('contas.nome as conta_nome, sum(financas.entrada_guarani - financas.saida_guarani) as saldo_gs').group('contas.nome')
			@contas_bancos_gs = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.tipo = 1 and financas.moeda = 1").select('contas.nome as conta_nome, sum(financas.entrada_guarani - financas.saida_guarani) as saldo_gs').group('contas.nome')
			@contas_cheque_dif_gs = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.tipo = 0 and financas.moeda = 1").select('contas.nome as conta_nome, sum(financas.entrada_guarani - financas.saida_guarani) as saldo_gs').group('contas.nome')


			@contas_cajas_rs = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.forma_pago_id = 1 and contas.tipo = 0 and financas.moeda = 2").select('contas.nome as conta_nome, sum(financas.entrada_real - financas.saida_real) as saldo_rs').group('contas.nome')
			@contas_bancos_rs = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.forma_pago_id IN (1,15) and contas.tipo = 1 and financas.moeda = 2").select('contas.nome as conta_nome, sum(financas.entrada_real - financas.saida_real) as saldo_rs').group('contas.nome')
			@contas_cheque_dif_rs = Financa.joins(:conta).where("contas.unidade_id = #{current_unidade.id} and contas.forma_pago_id = 6 and contas.tipo = 0 and financas.moeda = 2").select('contas.nome as conta_nome, sum(financas.entrada_real - financas.saida_real) as saldo_rs').group('contas.nome')			
		end
		
    sqlr = "SELECT PC.DESCRICAO AS RUBRO_NOME,
						       SUM(CC.TOTAL_REAL) AS VALOR_RS,
						       SUM(CC.TOTAL_GUARANI) AS VALOR_GS,
						       SUM(CC.TOTAL_DOLAR) AS VALOR_US
						FROM COMPRAS CC
						INNER JOIN PLANO_DE_CONTAS PC
						ON CC.PLANO_DE_CONTA_ID = PC.ID
						WHERE date_part('month', CC.data) = '#{Time.now.to_date.strftime("%m")}' and date_part('year', CC.data) = '#{Time.now.to_date.strftime("%Y")}'
						GROUP BY 1"


    @rubros = ComprasCusto.find_by_sql(sqlr)
    @rubros_sum_us = ComprasCusto.joins(:compra).where("compras.unidade_id = #{current_unidade.id} and compras.moeda = 0 and compras.tipo_compra = 1 and date_part('month', compras.data) = ? and date_part('year', compras.data) = ?", Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y")).sum('compras_custos.valor_us')
    @rubros_sum_gs = ComprasCusto.joins(:compra).where("compras.unidade_id = #{current_unidade.id} and compras.moeda = 1 and compras.tipo_compra = 1 and date_part('month', compras.data) = ? and date_part('year', compras.data) = ?", Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y")).sum('compras_custos.valor_gs')
    @rubros_sum_rs = ComprasCusto.joins(:compra).where("compras.unidade_id = #{current_unidade.id} and compras.moeda = 2 and compras.tipo_compra = 1 and date_part('month', compras.data) = ? and date_part('year', compras.data) = ?", Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y")).sum('compras_custos.valor_rs')

		render layout: 'chart'
	end

	def estrutura
			@menu = Menu.order('codigo')
	end

	def new
		@menu = Menu.new
		render layout: false
	end

	def edit
		@menu = Menu.find(params[:id])
		render layout: false
	end

	def create
			@menu = Menu.new(params[:menu])

			respond_to do |format|
					if @menu.save
							format.html { redirect_to(estrutura_menus_path) }
					else
							format.html { render :action => "new" }
							format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
					end
			end
	end

	def update
		@menu = Menu.find(params[:id])

		@menu.update_attributes(params[:menu])
		redirect_to(estrutura_menus_path)
	end

	def destroy                   #
			@menu = Menu.find(params[:id])
			@menu.destroy

			respond_to do |format|
					format.html { redirect_to(estrutura_menus_path) }
					format.xml  { head :ok }
			end
	end
end


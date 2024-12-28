class ContratosController < ApplicationController
	before_filter :authenticate

	def multi_faturamento
		@dividas = Cliente.where("liquidacao = 0 and tabela = 'CONTRATOS' and vencimento BETWEEN '2024-12-01' and '2024-12-31' " )

		render layout: 'chart'
	end
  def gera_titulos
  	@contrato = Contrato.find(params[:id])
    ContratoServico.destroy_all(contrato_id: @contrato.id)    
    venc = 0
    cota = 1
    PresupuestoProduto.where(presupuesto_id: @contrato.presupuesto_id).each do |pp|

    	ContratoServico.create(
    		contrato_id: @contrato.id,
    		persona_id: pp.persona_id,
    		produto_id: pp.produto_id,
    		quantidade: pp.quantidade,
    		unitario_gs: pp.unitario_guarani,
    		total_gs: pp.total_guarani
    	)

        venc = 0
        cota = 1
    end

		PresupuestoCota.where(presupuesto_id: @contrato.presupuesto_id).each do |pc|
			Cliente.create( persona_id: pc.persona_id,
			            titulo: (Cliente.last.id.to_i + 1),
			            cota: pc.cuotas,
			            unidade_id: @contrato.unidade_id,
			            moeda: @contrato.moeda,
			            liquidacao: 0,
			            divida_guarani: pc.valor_gs,
			            divida_dolar: 0,
			            divida_real: 0,
			            data: Time.now,
			            documento_numero: @contrato.id.to_s,
			            documento_numero_01: '000',
			            documento_numero_02: '000',
			            tabela_id: @contrato.id,
			            tabela: 'CONTRATOS',
			            cod_proc: @contrato.id,
			            sigla_proc: 'CT',
			            conta_id: @contrato.conta_id,
			            descricao: pc.produto.nome,
			            taxa: pc.produto.taxa,
			            tot_cotas: pc.cuotas,
			            vencimento: pc.vencimento.to_date,
			            centro_custo_id: pc.centro_custo_id )

		end


    redirect_to contrato_path(@contrato.id)
  end

	def cancelar 
		@contrato = Contrato.find(params[:id])
		@contrato.update_attributes(status: 'Cancelado')
		
		cotas_cont = Cliente.where(tabela: 'CONTRATOS', tabela_id: @contrato.id, liquidacao: 0 ).order(:id)		

		cotas_cont.each do |t|
					t.update_attributes(liquidacao: 1)
          Cliente.create( persona_id: t.persona_id,
            titulo: t.titulo,
            cota: t.cota,
            unidade_id: t.unidade_id,
            moeda: t.moeda,
            liquidacao: 1,
            divida_guarani: 0,
            divida_dolar: 0,
            divida_real: 0,
            cobro_guarani: t.divida_guarani,
            cobro_dolar: t.divida_dolar,
            cobro_real: t.divida_real,
            data: Time.now,
            documento_numero: t.documento_numero.to_s,
            documento_numero_01: t.documento_numero_01,
            documento_numero_02: t.documento_numero_02,
            tabela_id: t.id,
            tabela: 'CONTRATOS',
            cod_proc: t.id,
            sigla_proc: 'CT',
            conta_id: t.conta_id,
            descricao: (t.descricao + " CANCELADO"),
            tot_cotas: t.tot_cotas.to_i,
            vencimento: t.vencimento,
            centro_custo_id: t.centro_custo_id )			
		end

		redirect_to contrato_path(@contrato)
	end

	def busca
    params[:unidade] = current_unidade.id
    @contratos = Contrato.busca(params)
    render :layout => false
	end

	def financas
		@contrato = Contrato.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
		end
	end

	def index
	end

	def comprovante
		@contrato = Contrato.find(params[:id])
    @cotas_cont = Cliente.where(tabela: 'CONTRATOS', tabela_id: @contrato.id).order(:id)
    @contra_servis = ContratoServico.where(contrato_id: @contrato.id).order(:id)


					head =
						"                                                         #{current_unidade.nome_sys}
																														                    Demonstrativo de Resultado - Por Contrato
						"

			respond_to do |format|
			  if params[:tipo] == '1'
			    format.html {
			      xls = render_to_string :action => "comprovante", :layout => false
			      kit = PDFKit.new(xls,
			                       :encoding => 'UTF-8')
			      send_data(xls,:filename => "comprovante.xls")
			    }
			  else
						format.html do
							render  :pdf                    => "comprovante",
											:layout                 => "layer_relatorios",
											:margin => {:top        => '1.00in',
																	:bottom     => '0.25in',
																	:left       => '0.10in',
																	:right      => '0.10in'},
											:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																	:font_size  => 7,
																	:left       => head,
																	:spacing    => 18},
											:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																	:font_size  => 7,
																	:right      => "Pagina [page] de [toPage]",
																	:left       => "Chronos Smart - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
						end
					end
				end	end

	def show
		@contrato = Contrato.find(params[:id])
    @cotas_cont = Cliente.where(tabela: 'CONTRATOS', tabela_id: @contrato.id).order('cota,id')
    @contra_servis = ContratoServico.where(contrato_id: @contrato.id).order(:id)

    render layout: 'chart'
	end


	def new
		@contrato = Contrato.new

			doc = Contrato.select('id').last
			if doc == nil
				@last_doc = 1
			else
				@last_doc = doc.id
			end


    3.times do 
    	contrato_servicos =  @contrato.contrato_servicos.build     
    end
	end


	def edit
		@contrato = Contrato.find(params[:id])

    1.times do 
    	contrato_servicos =  @contrato.contrato_servicos.build     
    end

	end


	def create
		@contrato = Contrato.new(params[:contrato])

		respond_to do |format|
			if @contrato.save
				flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
				format.html { redirect_to contrato_path(@contrato) }
			else
				format.html { render action: "new" }
			end
		end
	end


	def update
		@contrato = Contrato.find(params[:id])

		respond_to do |format|
			if @contrato.update_attributes(params[:contrato])
				flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
				format.html { redirect_to contrato_path(@contrato) }
			else
				format.html { render action: "edit" }
			end
		end
	end


	def destroy
		@contrato = Contrato.find(params[:id])
		@contrato.destroy

		respond_to do |format|
			format.html { redirect_to contratos_url }
		end
	end
end

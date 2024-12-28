class TrocasController < ApplicationController


	def busca_produtos_faturados
		sql = " SELECT p.id as produto_id, p.nome, m.nome as fabricante, p.stock, unitario_guarani
				 FROM vendas
				 INNER JOIN vendas_produtos vp ON vp.venda_id = vendas.id
				 INNER JOIN produtos p ON p.id = vp.produto_id
				 LEFT OUTER JOIN marcas m ON m.id = p.fabricante_id
				 WHERE vp.vendedor_id = #{params[:vendedor_id]} AND vp.persona_id = #{params[:persona_id]}"

		@produtos  = Produto.find_by_sql(sql)

		render :layout => "consulta"
	end

	def index
		@trocas = Troca.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @trocas }
		end
	end


	def show
		@troca = Troca.find(params[:id])

		entrada = TrocaProduto.where(status: true, troca_id: @troca.id).sum( 'total_gs')
		saida = TrocaProduto.where(status: false, troca_id: @troca.id).sum( 'total_gs')
		@valor_total_atual = saida.to_f  - entrada.to_f

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @troca }
		end
	end


	def new
		@troca = Troca.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @troca }
		end
	end


	def edit
		@troca = Troca.find(params[:id])
	end


	def create
		@troca = Troca.new(params[:troca])

		respond_to do |format|
			if @troca.save
				flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
				format.html { redirect_to troca_path(@troca) }
			else
				format.html { render action: "new" }
			end
		end
	end


	def update
		@troca = Troca.find(params[:id])

		respond_to do |format|
			if @troca.update_attributes(params[:troca])
			 	flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
				format.html { redirect_to troca_path(@troca) }
			else
				format.html { render action: "edit" }
			end
		end
	end

	# DELETE /trocas/1
	# DELETE /trocas/1.json
	def destroy
		@troca = Troca.find(params[:id])
		@troca.destroy

		respond_to do |format|
			format.html { redirect_to trocas_url }
			format.json { head :no_content }
		end
	end
end

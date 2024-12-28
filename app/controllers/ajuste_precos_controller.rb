class AjustePrecosController < ApplicationController

	def index
		@ajuste_precos = AjustePreco.where("unidade_id = #{current_unidade.id}").order('id desc')

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @ajuste_precos }
		end
	end


	def show
		@ajuste_preco = AjustePreco.find(params[:id])
		@produtos = AjustePrecoDetalhe.where("ajuste_preco_id = #{@ajuste_preco.id}")
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @ajuste_preco }
		end
	end


	def new
		@ajuste_preco = AjustePreco.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @ajuste_preco }
		end
	end

	# GET /ajuste_precos/1/edit
	def edit
		@ajuste_preco = AjustePreco.find(params[:id])
	end


	def create
		@ajuste_preco = AjustePreco.new(params[:ajuste_preco])
		@ajuste_preco.unidade_id = current_unidade.id.to_i

		respond_to do |format|
			if @ajuste_preco.save
				format.html { redirect_to @ajuste_preco, notice: 'Ajuste preco was successfully created.' }
				format.json { render json: @ajuste_preco, status: :created, location: @ajuste_preco }
			else
				format.html { render action: "new" }
				format.json { render json: @ajuste_preco.errors, status: :unprocessable_entity }
			end
		end
	end


	def update
		@ajuste_preco = AjustePreco.find(params[:id])

		respond_to do |format|
			if @ajuste_preco.update_attributes(params[:ajuste_preco])
				format.html { redirect_to @ajuste_preco, notice: 'Ajuste preco was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @ajuste_preco.errors, status: :unprocessable_entity }
			end
		end
	end


	def destroy
		@ajuste_preco = AjustePreco.find(params[:id])
		@ajuste_preco.destroy

		respond_to do |format|
			format.html { redirect_to ajuste_precos_url }
			format.json { head :no_content }
		end
	end
end

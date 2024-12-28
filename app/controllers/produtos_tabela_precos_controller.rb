class ProdutosTabelaPrecosController < ApplicationController

	def index
		@produtos_tabela_precos = ProdutosTabelaPreco.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @produtos_tabela_precos }
		end
	end


	def show
		@produtos_tabela_preco = ProdutosTabelaPreco.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @produtos_tabela_preco }
		end
	end


	def new
		@produtos_tabela_preco = ProdutosTabelaPreco.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @produtos_tabela_preco }
		end
	end


	def edit
		@produtos_tabela_preco = ProdutosTabelaPreco.find(params[:id])
	end


	def create
		@produtos_tabela_preco = ProdutosTabelaPreco.new(params[:produtos_tabela_preco])

		respond_to do |format|
			if @produtos_tabela_preco.save
				format.html { redirect_to @produtos_tabela_preco, notice: 'Produtos tabela preco was successfully created.' }
				format.json { render json: @produtos_tabela_preco, status: :created, location: @produtos_tabela_preco }
			else
				format.html { render action: "new" }
				format.json { render json: @produtos_tabela_preco.errors, status: :unprocessable_entity }
			end
		end
	end


	def update
		@produtos_tabela_preco = ProdutosTabelaPreco.find(params[:id])

		respond_to do |format|
			if @produtos_tabela_preco.update_attributes(params[:produtos_tabela_preco])
				format.html { redirect_to "/produtos/#{@produtos_tabela_preco.produto_id}/tabelas_precos"}
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @produtos_tabela_preco.errors, status: :unprocessable_entity }
			end
		end
	end


	def destroy
		@produtos_tabela_preco = ProdutosTabelaPreco.find(params[:id])
		@produtos_tabela_preco.destroy

		respond_to do |format|
			format.html { redirect_to produtos_tabela_precos_url }
			format.json { head :no_content }
		end
	end
end

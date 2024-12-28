module Api
	module V1
		class VendasProdutosController < ApplicationController
			# Listar todos os artigos
			def index
				vendas_produtos = VendasProduto.order('created_at DESC');
				render json: {status: 'SUCCESS', message:'Vendas Produtos carregados', data:vendas_produtos},status: :ok
			end
			# Listar artigo passando ID
			def show
				vendas_produto = VendasProduto.find(params[:id])
				render json: {status: 'SUCCESS', message:'Loaded vendas', data:vendas_produto},status: :ok
			end

			# Criar um novo artigo
			def create
				vendas_produto = VendasProduto.new(params[:vendas_produto])
				if vendas_produto.save
					render json: {status: 'SUCCESS', message:'Saved vendas_produto', data:vendas_produto},status: :ok
				else
					render json: {status: 'ERROR', message:'vendas_produto not saved', data:vendas_produto.erros},status: :unprocessable_entity
				end
			end
			# Excluir artigo
			def destroy
				vendas_produto = VendasProduto.find(params[:id])
				vendas_produto.destroy
				render json: {status: 'SUCCESS', message:'Deleted vendas_produto', data:vendas_produto},status: :ok
			end
			# Atualizar um artigo
			def update
				vendas_produto = VendasProduto.find(params[:id])
				if vendas_produto.update_attributes(params[:vendas_produto])
					render json: {status: 'SUCCESS', message:'Updated venda', data:vendas_produto},status: :ok
				else
					render json: {status: 'ERROR', message:'Articles not update', data:vendas_produto.erros},status: :unprocessable_entity
				end
			end
			
		end
	end
end
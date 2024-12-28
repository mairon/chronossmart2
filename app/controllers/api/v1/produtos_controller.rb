module Api
	module V1
		class ProdutosController < ApplicationController
			# Listar todos os artigos
			def index
				produtos = Produto.order('created_at DESC');
				render json: {status: 'SUCCESS', message:'Artigos carregados', data:produtos},status: :ok
			end
			# Listar artigo passando ID
			def show
				produto = Produto.find(params[:id])
				render json: {status: 'SUCCESS', message:'Loaded produto', data:produto},status: :ok
			end

			# Criar um novo artigo
			def create
				produto = Produto.new(params[:produto])
				if produto.save
					render json: {status: 'SUCCESS', message:'Saved produto', data:produto},status: :ok
				else
					render json: {status: 'ERROR', message:'produto not saved', data:produto.erros},status: :unprocessable_entity
				end
			end
			# Excluir artigo
			def destroy
				produto = Produto.find(params[:id])
				produto.destroy
				render json: {status: 'SUCCESS', message:'Deleted produto', data:produto},status: :ok
			end
			# Atualizar um artigo
			def update
				produto = Produto.find(params[:id])
				if produto.update_attributes(params[:produto])
					render json: {status: 'SUCCESS', message:'Updated produto', data:produto},status: :ok
				else
					render json: {status: 'ERROR', message:'Articles not update', data:produto.erros},status: :unprocessable_entity
				end
			end
			
		end
	end
end
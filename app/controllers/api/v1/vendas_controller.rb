module Api
	module V1
		class VendasController < ApplicationController
			# Listar todos os artigos
			def index
				vendas = Venda.order('created_at DESC');
				render json: {status: 'SUCCESS', message:'Vendas carregados', data:vendas},status: :ok
			end
			# Listar artigo passando ID
			def show
				venda = Venda.find(params[:id])
				render json: {status: 'SUCCESS', message:'Loaded vendas', data:venda},status: :ok
			end

			# Criar um novo artigo
			def create
				venda = Venda.new(params[:venda])
				if venda.save
					render json: {status: 'SUCCESS', message:'Saved venda', data:venda},status: :ok
				else
					render json: {status: 'ERROR', message:'venda not saved', data:venda.erros},status: :unprocessable_entity
				end
			end
			# Excluir artigo
			def destroy
				venda = Venda.find(params[:id])
				venda.destroy
				render json: {status: 'SUCCESS', message:'Deleted venda', data:venda},status: :ok
			end
			# Atualizar um artigo
			def update
				venda = Venda.find(params[:id])
				if venda.update_attributes(params[:venda])
					render json: {status: 'SUCCESS', message:'Updated venda', data:venda},status: :ok
				else
					render json: {status: 'ERROR', message:'Articles not update', data:venda.erros},status: :unprocessable_entity
				end
			end
			
		end
	end
end
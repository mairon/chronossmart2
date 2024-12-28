class TrocaProdutosController < ApplicationController

	def index
		@troca_produtos = TrocaProduto.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @troca_produtos }
		end
	end


	def show
		@troca_produto = TrocaProduto.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @troca_produto }
		end
	end


	def new
		@troca_produto = TrocaProduto.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @troca_produto }
		end
	end


	def edit
		@troca_produto = TrocaProduto.find(params[:id])
	end


	def create
		@troca_produto = TrocaProduto.new(params[:troca_produto])

		respond_to do |format|
			if @troca_produto.save
				flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
				format.html { redirect_to troca_path(@troca_produto.troca_id) }
			else
				format.html { render action: "new" }
				format.json { render json: @troca_produto.errors, status: :unprocessable_entity }
			end
		end
	end


	def update
		@troca_produto = TrocaProduto.find(params[:id])

		respond_to do |format|
			if @troca_produto.update_attributes(params[:troca_produto])
				format.html { redirect_to @troca_produto, notice: 'Troca produto was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @troca_produto.errors, status: :unprocessable_entity }
			end
		end
	end


	def destroy
		@troca_produto = TrocaProduto.find(params[:id])
		@troca_produto.destroy

		respond_to do |format|
			flash[:notice] = t('SUCESSFUL_DELETION_MESSAGE')
			format.html { redirect_to troca_path(@troca_produto.troca_id) }
		end
	end
end

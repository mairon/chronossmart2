class BocaCxProdutosController < ApplicationController

	def index
		@boca_cx_produtos = BocaCxProduto.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @boca_cx_produtos }
		end
	end


	def show
		@boca_cx_produto = BocaCxProduto.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @boca_cx_produto }
		end
	end


	def new
		@boca_cx_produto = BocaCxProduto.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @boca_cx_produto }
		end
	end


	def edit
		@boca_cx_produto = BocaCxProduto.find(params[:id])
	end


	def create
		@boca_cx_produto = BocaCxProduto.new(params[:boca_cx_produto])

		respond_to do |format|
			if @boca_cx_produto.save
				flash[:notice] =t('SAVE_SUCESSFUL_MESSAGE')
				format.html { redirect_to boca_cx_path(@boca_cx_produto.boca_cx_id) }
			else
				format.html { render action: "new" }
			end
		end
	end


	def update
		@boca_cx_produto = BocaCxProduto.find(params[:id])

		respond_to do |format|
			if @boca_cx_produto.update_attributes(params[:boca_cx_produto])
				 flash[:notice] =t('SAVE_SUCESSFUL_MESSAGE')
				format.html { redirect_to boca_cx_path(@boca_cx_produto.boca_cx_id) }
			else
				format.html { render action: "edit" }
			end
		end
	end


	def destroy
		@boca_cx_produto = BocaCxProduto.find(params[:id])
		@boca_cx_produto.destroy

		respond_to do |format|
			 flash[:notice] =t('SUCESSFUL_DELETION_MESSAGE')
			format.html { redirect_to boca_cx_path(@boca_cx_produto.boca_cx_id) }
		end
	end
end

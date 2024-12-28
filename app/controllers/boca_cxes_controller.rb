class BocaCxesController < ApplicationController

	def index
		@boca_cxes = BocaCx.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @boca_cxes }
		end
	end


	def show
		@boca_cx = BocaCx.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @boca_cx }
		end
	end


	def new
		@boca_cx = BocaCx.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @boca_cx }
		end
	end


	def edit
		@boca_cx = BocaCx.find(params[:id])
	end


	def create
		@boca_cx = BocaCx.new(params[:boca_cx])

		respond_to do |format|
			if @boca_cx.save
				flash[:notice] =t('SAVE_SUCESSFUL_MESSAGE')
				format.html { redirect_to boca_cxes_url }
			else
				format.html { render action: "new" }
			end
		end
	end


	def update
		@boca_cx = BocaCx.find(params[:id])

		respond_to do |format|
			if @boca_cx.update_attributes(params[:boca_cx])
				format.html { redirect_to boca_cxes_url }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
			end
		end
	end


	def destroy
		@boca_cx = BocaCx.find(params[:id])
		@boca_cx.destroy

		respond_to do |format|
			flash[:notice] =t('SUCESSFUL_DELETION_MESSAGE')
			format.html { redirect_to boca_cxes_url }
		end
	end
end

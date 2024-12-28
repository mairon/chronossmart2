class ContasController < ApplicationController
before_filter :authenticate

def gera_docs

    inicio = params[:doc_inicio].to_i
    final  = params[:doc_final].to_i
	sequencia = inicio
    (inicio..final).each do |i|

      ContaCheque.create(  conta_id: params[:conta_id],
                          obs: params[:obs],
                          numero: sequencia,
                          status: 0,
                        )

      sequencia += 1
    end
    redirect_to conta_path(params[:conta_id])
  end

 def index
		@contas = Conta.where("unidade_id = #{current_unidade.id}").order('id desc')

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @contas }
		end
	end

	def show
		@conta = Conta.find(params[:id])

		@conta_cheques = ContaCheque.where("conta_id = #{params[:id]}")

		render layout: 'chart'
	end

	def new
		@conta = Conta.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @conta }
		end
	end

	def edit
		@conta = Conta.find(params[:id])
	end

	def create
		@conta = Conta.new(params[:conta])
		@conta.usuario_created = current_user.usuario_nome
		@conta.unidade_created = current_unidade.unidade_nome

		respond_to do |format|
			if @conta.save
				if Conta.count == 1
					format.html { redirect_to menus_path }
				else
					flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
					format.html { redirect_to(contas_url) }
					format.xml  { render :xml => @conta, :status => :created, :location => @conta }
				end
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @conta.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		@conta = Conta.find(params[:id])
		@conta.usuario_updated = current_user.usuario_nome
		@conta.unidade_updated = current_unidade.unidade_nome

		respond_to do |format|
			if @conta.update_attributes(params[:conta])
				flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
				format.html { redirect_to(contas_url) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @conta.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@conta = Conta.find(params[:id])
		@conta.destroy

		respond_to do |format|
			format.html { redirect_to(contas_url) }
			format.xml  { head :ok }
		end
	end
end


module Api
	module V1
		class PostbackController < ApplicationController
			# Listar todos os artigos
			def index
				render json: {status: 'SUCCESS', message:'Recebido', status: 200 }
			end						
		end
	end
end
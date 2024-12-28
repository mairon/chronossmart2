class SuportesController < ApplicationController

	def comando
	end

    def consulta
        Suporte.find_by_sql(params[:consulta])
        
        redirect_to comando_suportes_path

        flash[:notice] = 'Processo Efetuado con Exito!'
    end
end

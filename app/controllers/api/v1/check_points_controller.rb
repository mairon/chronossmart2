module Api
	module V1
		class CheckPointsController < ApplicationController
			# Listar todos os artigos
			def index

				sql = "SELECT CP.ID,
											CP.CHECK_POINT_TYPE,
											CP.DATETIME AS CHECK_POINT_HOURS,
											P.USUARIO_ID AS PERSONA_ID

							FROM CHECK_POINTS CP
							INNER JOIN PERSONAS P
							ON P.ID = CP.PERSONA_ID
							WHERE CP.IMPORT = FALSE
							AND P.USUARIO_ID IS NOT NULL"

				check_points = CheckPoint.find_by_sql(sql);

				check_points.each do |cp|
					cp.update_attribute :import, true					
				end

				render json: {status: 'SUCCESS', message:'Points carregados', data:check_points}, status: :ok
			end			
		end
	end
end

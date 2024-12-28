class Crm::MainController < Crm::CrmController

	def index 
		@pipeline = Pipeline.last
		@negocio = Negocio.new
		@steps = Etapa.where(pipeline_id: @pipeline.id).order(:ordem)

		render layout: 'crm'
	end
end
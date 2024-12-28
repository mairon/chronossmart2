class ComprasGasto < ActiveRecord::Base
	belongs_to :compra
	before_save :cals

	def cals
		self.tipo_compra  = compra.tipo_compra
		self.persona_id   = compra.persona_id
		self.persona_nome = compra.persona_nome
		self.data         = compra.data
		self.cotacao      = compra.cotacao
		self.unidade_id   = compra.unidade_id
		self.tipo         = compra.tipo
		self.moeda        = compra.moeda

		@rubro = Rubro.find_by_id(self.rubro_id,:select => 'id,descricao,codigo')
		self.rubro_descricao    = @rubro.descricao.to_s
		self.rubro_cod_contabil = @rubro.codigo.to_s


		#CALCULO COTACAO FATURA
		if self.moeda == 0
			#dolar / guarani

			self.exentas_guarani     =  self.exentas_dolar.to_f  * compra.cotacao.to_f
			self.gravadas_05_guarani =  self.gravadas_05_dolar.to_f * compra.cotacao.to_f
			self.gravadas_10_guarani =  self.gravadas_10_dolar.to_f * compra.cotacao.to_f
			self.imposto_05_guarani  =  self.imposto_05_dolar.to_f * compra.cotacao.to_f
			self.imposto_10_guarani  =  self.imposto_10_dolar.to_f * compra.cotacao.to_f
			self.total_guarani       =  self.total_dolar.to_f * compra.cotacao.to_f
			self.desconto_guarani    =  self.desconto_dolar.to_f * compra.cotacao.to_f

			#guarani / real
			if compra.cotacao_real > 0
				self.exentas_real     =  self.exentas_guarani.to_f  / compra.cotacao_real.to_f
				self.gravadas_05_real =  self.gravadas_05_guarani.to_f / compra.cotacao_real.to_f
				self.gravadas_10_real =  self.gravadas_10_guarani.to_f / compra.cotacao_real.to_f
				self.imposto_05_real  =  self.imposto_05_guarani.to_f / compra.cotacao_real.to_f
				self.imposto_10_real  =  self.imposto_10_guarani.to_f / compra.cotacao_real.to_f
				self.total_real       =  self.total_guarani.to_f / compra.cotacao_real.to_f
				self.desconto_real    =  self.desconto_guarani.to_f / compra.cotacao_real.to_f
			end

			elsif self.moeda == 1
				 #guarani / dolar
				self.exentas_dolar     =  self.exentas_guarani.to_f  / compra.cotacao.to_f
				self.gravadas_05_dolar =  self.gravadas_05_guarani.to_f / compra.cotacao.to_f
				self.gravadas_10_dolar =  self.gravadas_10_guarani.to_f / compra.cotacao.to_f
				self.imposto_05_dolar  =  self.imposto_05_guarani.to_f / compra.cotacao.to_f
				self.imposto_10_dolar  =  self.imposto_10_guarani.to_f / compra.cotacao.to_f
				self.total_dolar       =  self.total_guarani.to_f / compra.cotacao.to_f
				self.desconto_dolar    =  self.desconto_guarani.to_f / compra.cotacao.to_f
				#guarani / real

				if compra.cotacao_real > 0
					self.exentas_real     =  self.exentas_guarani.to_f  / compra.cotacao_real.to_f
					self.gravadas_05_real =  self.gravadas_05_guarani.to_f / compra.cotacao_real.to_f
					self.gravadas_10_real =  self.gravadas_10_guarani.to_f / compra.cotacao_real.to_f
					self.imposto_05_real  =  self.imposto_05_guarani.to_f / compra.cotacao_real.to_f
					self.imposto_10_real  =  self.imposto_10_guarani.to_f / compra.cotacao_real.to_f
					self.total_real       =  self.total_guarani.to_f / compra.cotacao_real.to_f
					self.desconto_real    =  self.desconto_guarani.to_f / compra.cotacao_real.to_f
				end
			else

			 #real / guarani
			if compra.cotacao_real > 0
				self.exentas_guarani     =  self.exentas_real.to_f  * compra.cotacao_real.to_f
				self.gravadas_05_guarani =  self.gravadas_05_real.to_f * compra.cotacao_real.to_f
				self.gravadas_10_guarani =  self.gravadas_10_real.to_f * compra.cotacao_real.to_f
				self.imposto_05_guarani  =  self.imposto_05_real.to_f * compra.cotacao_real.to_f
				self.imposto_10_guarani  =  self.imposto_10_real.to_f * compra.cotacao_real.to_f
				self.total_guarani       =  self.total_real.to_f * compra.cotacao_real.to_f
				#real / dolar
				self.exentas_dolar     =  self.exentas_guarani.to_f  / compra.cotacao.to_f
				self.gravadas_05_dolar =  self.gravadas_05_guarani.to_f / compra.cotacao.to_f
				self.gravadas_10_dolar =  self.gravadas_10_guarani.to_f / compra.cotacao.to_f
				self.imposto_05_dolar  =  self.imposto_05_guarani.to_f / compra.cotacao.to_f
				self.imposto_10_dolar  =  self.imposto_10_guarani.to_f / compra.cotacao.to_f
				self.total_dolar       =  self.total_guarani.to_f / compra.cotacao.to_f
			end
		end
	end
end

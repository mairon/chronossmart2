class EntradaResultEnsaio < ActiveRecord::Base
	belongs_to :entrada_result

	before_save :calcs_formulas, :finds
	
	def aluminio?
    self.metodo_id.to_i != 16
  end
	def calcs_formulas
		form = Metodo.find_by_id(entrada_result.metodo_id)
		if entrada_result.tipo_leitura == 0
			self.resultado =  self.leitura01.to_f
		else
			#leituras solo - granulometria
			if entrada_result.metodo_id.to_i == 140
				self.resultado =  ( (self.leitura01.to_f - self.peso_cadinho_peso ) - 0.004 ) * 500
			#leituras fisicas - silte
				self.resultado_silte =  ( ( ( ( self.leitura02.to_f - self.peso_cadinho_peso_silte ) - 0.004 ) * 500) - self.resultado.to_f )
			#leituras calcio - granulometria
			elsif entrada_result.metodo_id.to_i == 180
				self.cal_p10_result = (self.cal_p10.to_f * 0)
				self.cal_p20_result = (self.cal_p20.to_f * 0.2)
				self.cal_p50_result = (self.cal_p50.to_f * 0.6)
				self.cal_fundo_result = (self.cal_fundo.to_f * 1)

			elsif entrada_result.metodo_id.to_i == 195
				find_curva = EntradaCurva.last
					calc_sub = form.formula.to_s.gsub('F', self.fator.to_s).gsub('D', self.diluicao.to_s).gsub('PB', self.pb.to_s).gsub('L',self.leitura01.to_f.to_s)
					self.resultado  = ((find_curva.y.to_f * eval(calc_sub).to_f) + find_curva.x.to_f)
					self.formula = calc_sub

			else
				#outras leituras
				unless form.formula.blank?
					calc_sub = form.formula.to_s.gsub('F', self.fator.to_s).gsub('D', self.diluicao.to_s).gsub('PB', self.pb.to_s).gsub('L',self.leitura01.to_f.to_s)
					self.resultado =  eval(calc_sub).to_f
					self.formula = calc_sub
				end
			end
		end
	end

	def finds
		if self.leitura01.to_f != nil
			self.status = 1
		end
	end
end

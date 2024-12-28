class VendaDevolucao < ActiveRecord::Base
	belongs_to :produto

	after_save :gera_credito
	after_destroy :gera_credito_destroy

	def gera_credito
		Cliente.where(tabela_id: self.venda_id, tabela: 'VENDAS_DEVOLUCAOS' ).destroy_all

		vt = Venda.find(self.venda_id)
		vd = VendaDevolucao.where(venda_id: self.venda_id)

		Cliente.create(
				tabela_id: self.venda_id,
				tabela: 'VENDAS_DEVOLUCAOS',
				documento_numero_01: 'DV0',
				documento_numero_02: '000',
				documento_numero: self.venda_id,
				cota: 1,
				divida_guarani: 0,
				divida_dolar: 0,
				divida_real: 0,
				cobro_guarani: vd.sum("quantidade * unit_gs").to_f,
				cobro_dolar: vd.sum("quantidade * unit_us").to_f,
				cobro_real: vd.sum("quantidade * unit_rs").to_f,
				liquidacao: 0,
				moeda: self.moeda,
				vendedor_id: vt.vendedor_id,
				sigla_proc: 'DV',
				cod_proc: self.venda_id,
				unidade_id: vt.vendedor_id,
				data: self.data,
				vencimento: self.data,
				persona_id: vt.persona_id,

			)
	end

	def gera_credito_destroy
		Cliente.where(tabela_id: self.venda_id, tabela: 'VENDAS_DEVOLUCAOS' ).destroy_all

		vt = Venda.find(self.venda_id)
		vd = VendaDevolucao.where(venda_id: self.venda_id)
		if vd.count(:id) > 0 
		Cliente.create(
				tabela_id: self.venda_id,
				tabela: 'VENDAS_DEVOLUCAOS',
				documento_numero_01: 'DV0',
				documento_numero_02: '000',
				documento_numero: self.venda_id,
				cota: 1,
				divida_guarani: 0,
				divida_dolar: 0,
				divida_real: 0,
				cobro_guarani: vd.sum("quantidade * unit_gs").to_f,
				cobro_dolar: vd.sum("quantidade * unit_us").to_f,
				cobro_real: vd.sum("quantidade * unit_rs").to_f,
				liquidacao: 0,
				moeda: self.moeda,
				vendedor_id: vt.vendedor_id,
				sigla_proc: 'DV',
				cod_proc: self.venda_id,
				unidade_id: vt.vendedor_id,
				data: self.data,
				vencimento: self.data,
				persona_id: vt.persona_id,

			)
		end	
	end	
end

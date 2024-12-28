class VendasFatura < ActiveRecord::Base
	belongs_to :venda
  validates_uniqueness_of :documento_numero, scope: [:timbrado, :documento_numero_01,
                          :documento_numero_02, :unidade_id], message: " ja cadastrado."


	after_update :atuliza_documento_financas

	def atuliza_documento_financas
		if self.status.to_i == 1
    vendas_financas = VendasFinanca.where("venda_id = #{self.venda_id}")
    vendas_financas.each do |vf|
      vf.update_attributes(fatura: 0, documento_numero_01: '000', documento_numero_02: '000', documento_numero: self.venda_id, documento_nome: 'COMPROBANTE VENTA', documento_id: 10)
    end
		end 
	end
end

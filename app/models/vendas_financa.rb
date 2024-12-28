class VendasFinanca < ActiveRecord::Base
	#audit(:create, :update, :destroy) { |model, user, action| "|#{model.venda_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
	belongs_to :venda
	belongs_to :persona
	belongs_to :usuario
	belongs_to :forma_pago
	belongs_to :cartao
	before_save :calcs
	#before_destroy :calcs_delete
	before_destroy :reabre_comanda, :liquida_contrato
	after_save :aplica_desc, :fecha_comanda, :liquida_contrato


  def fecha_comanda
  	puts "vendas_financas After Save"
  	ct = Cartao.find_by_id(venda.cartao_id)
    ct.update_attributes(status_op: 0) unless venda.cartao.nil?
  end

  def reabre_comanda
  	puts "vendas_financas before_destroy"
  	ct = Cartao.find_by_id(venda.cartao_id)
    ct.update_attributes(status_op: 1, venda_id: self.venda_id) unless venda.cartao.nil?
  end

	def calcs

    if self.forma_pago_id == 1
    	self.cartao_bandeira_id = 0
    end

		self.vendedor_id   = venda.vendedor_id
		self.vendedor_nome = venda.vendedor_nome

		if self.forma_pago.tipo.to_i == 0 and self.forma_pago.id != 15
			cfp = ContasFormaPago.joins(:conta).where("contas_forma_pagos.forma_pago_id = #{self.forma_pago_id} and contas.moeda = #{self.moeda} and contas.terminal_id = #{venda.terminal_id}").last
			self.conta_id   = cfp.conta_id.to_s
		end

		conta_vuelto = Conta.find_by_id(self.vuelto_conta_id);
		self.vuelto_conta_nome   = conta_vuelto.nome.to_s unless self.vuelto_conta_id.blank?

		if self.tipo.to_i == 0
			self.vencimento = self.data
			self.cheque_valor_dolar = self.valor_dolar_contado
			self.cheque_valor_guarani = self.valor_guarani_contado
		else
			self.diferido = self.data
		end
	end

	def aplica_desc

		if self.desconto.to_f > 0
			if self.moeda.to_i == 0
				sum_us  = VendasProduto.sum(('preco_dolar * quantidade'), :conditions => ['venda_id = ?', self.venda_id]) 
				tot_desc_dolar   = (sum_us.to_f * (self.desconto.to_f / 100))
			else
			  sum_gs  = VendasProduto.sum(('preco_guarani * quantidade'), :conditions => ['venda_id = ?', self.venda_id]) 
			  tot_desc_guarani = (sum_gs.to_f * (self.desconto.to_f / 100 )) # (100.329 * (0.0033)) 331.0857
			end

			prod = VendasProduto.all(:conditions => ["venda_id = ?", self.venda_id])

			prod.each do |pd|
			 	if self.moeda.to_i == 0
					tot_us = ( pd.preco_dolar.to_f * pd.quantidade.to_f ).round(4)

					porcen_us    = ( ( tot_us.to_f * 100 ) / sum_us.to_f )
					desc_us =  ( tot_us.to_f - ( ( tot_desc_dolar.to_f * porcen_us.to_f ) / 100 ) )

					pd.update_attribute :unitario_dolar, ((desc_us.to_f / pd.quantidade.to_f).to_f)
					pd.update_attribute :total_dolar, ((desc_us.to_f))

					pd.update_attribute :unitario_guarani, ((pd.preco_dolar.to_f - desc_us.to_f) * venda.cotacao.to_f)
					pd.update_attribute :total_guarani, (((pd.preco_dolar.to_f - desc_us.to_f) * pd.quantidade.to_f) * venda.cotacao.to_f)
			 	else
					tot_gs    = ( pd.preco_guarani.to_f * pd.quantidade.to_f ).round(0)
					porcen_gs = ( ( tot_gs.to_f * 100 ) / sum_gs.to_f ) #100
					desc_gs   =  ( tot_gs.to_f - ( ( tot_desc_guarani.to_f * porcen_gs.to_f ) / 100 ) ) #(33108.57)

					pd.update_attribute :unitario_guarani, ((desc_gs.to_f / pd.quantidade.to_f).to_f)
					pd.update_attribute :total_guarani, ((desc_gs.to_f))

					pd.update_attribute :unitario_dolar, (((desc_gs.to_f / pd.quantidade.to_f).to_f) / venda.cotacao.to_f)
					pd.update_attribute :total_dolar, (((desc_gs.to_f)) / venda.cotacao.to_f)

			 	end
			end
		end
	end

	def calcs_delete
		if  self.desconto.to_f > 0
			prod = VendasProduto.all(:conditions => ["venda_id = ?", self.venda_id])

			prod.each do |pd|
			 	if self.moeda.to_i == 0
					pd.update_attribute :unitario_dolar, (pd.preco_dolar.to_f)
					pd.update_attribute :total_dolar, (pd.preco_dolar.to_f) * pd.quantidade.to_f
			 	else
					pd.update_attribute :unitario_guarani, (pd.preco_guarani.to_f)
					pd.update_attribute :total_guarani, (pd.preco_guarani.to_f) * pd.quantidade.to_f
			 	end
			end
		end
	end


  def liquida_contrato
    if venda.contrato_id.to_i > 0
    	doc = Cliente.where( persona_id: venda.persona_id, cod_proc: venda.contrato_id, cota: venda.cota, tabela: 'CONTRATOS' ).last
      titulo = Cliente.where( persona_id: venda.persona_id, documento_numero_01: doc.documento_numero_01, documento_numero_02: doc.documento_numero_02, cota: venda.cota, documento_numero: doc.documento_numero )
      if venda.moeda.to_i == 0
        div_us = Cliente.where( persona_id: venda.persona_id, documento_numero_01: doc.documento_numero_01, documento_numero_02: doc.documento_numero_02, cota: venda.cota, documento_numero: doc.documento_numero ).sum(:divida_dolar)
        pago_us = Cliente.where( persona_id: venda.persona_id, documento_numero_01: doc.documento_numero_01, documento_numero_02: doc.documento_numero_02, cota: venda.cota, documento_numero: doc.documento_numero ).sum(:cobro_dolar)
        if div_us.to_f == pago_us.to_f
          titulo.each do |t|
            t.update_attribute :liquidacao, 1
          end
          
        else
          titulo.each do |t|
            t.update_attribute :liquidacao, 0
          end
        end
      elsif venda.moeda.to_i == 1
        div_gs = Cliente.where( persona_id: venda.persona_id, documento_numero_01: doc.documento_numero_01, documento_numero_02: doc.documento_numero_02, cota: venda.cota, documento_numero: doc.documento_numero ).sum(:divida_guarani)
        pago_gs = Cliente.where( persona_id: venda.persona_id, documento_numero_01: doc.documento_numero_01, documento_numero_02: doc.documento_numero_02, cota: venda.cota, documento_numero: doc.documento_numero ).sum(:cobro_guarani)
        if div_gs.to_f == pago_gs.to_f
          titulo.each do |t|
            t.update_attribute :liquidacao, 1
          end
          
        else
          titulo.each do |t|
            t.update_attribute :liquidacao, 0
          end
        end

      elsif venda.moeda.to_i == 2
        div_rs = Cliente.where( persona_id: venda.persona_id, documento_numero_01: doc.documento_numero_01, documento_numero_02: doc.documento_numero_02, cota: venda.cota, documento_numero: doc.documento_numero ).sum(:divida_real)
        pago_rs = Cliente.where( persona_id: venda.persona_id, documento_numero_01: doc.documento_numero_01, documento_numero_02: doc.documento_numero_02, cota: venda.cota, documento_numero: doc.documento_numero ).sum(:cobro_real)
        if div_rs.to_f == pago_rs.to_f
          titulo.each do |t|
            t.update_attribute :liquidacao, 1
          end
          
        else
          titulo.each do |t|
            t.update_attribute :liquidacao, 0
          end
        end

      end
    end
  end

end

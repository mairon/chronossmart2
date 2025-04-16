class FechamentoCaixaDt < ActiveRecord::Base
	belongs_to :forma_pago
	belongs_to :fechamento_caixa
	belongs_to :cartao_bandeira
	before_update :transfere_valores

	#after_create :send_forma_pago_efetivo
	before_create :finds
	after_create :send_transf_efetivo
	before_destroy :destroy_tranf_efetivo

	def destroy_tranf_efetivo
		if self.forma_pago_id == 1 or self.forma_pago_id == 17
			Financa.destroy_all("tabela = 'FECHAMENTO_CAIXAS' and tabela_id = #{self.id} " )
		end
	end

	def finds
		if self.forma_pago_id == 17
			c = Conta.find_by_id(self.conta_origem_id)
			self.moeda = c.moeda.to_i
		end
	end

	def send_transf_efetivo
		if self.forma_pago_id == 17
	    if self.moeda.to_i == 0
	      var_us = self.valor.to_f
	      var_gs = 0
	      var_rs = 0
	      var_ps = 0

	    elsif self.moeda.to_i == 1
	      var_us = 0
	      var_gs = self.valor.to_f
	      var_rs = 0
	      var_ps = 0

	  	elsif self.moeda.to_i == 2
	      var_us = 0
	      var_gs = 0
	      var_rs = self.valor.to_f
	      var_ps = 0

	  	elsif self.moeda.to_i == 3
	      var_us = 0
	      var_gs = 0
	      var_rs = 0
	      var_ps = self.valor.to_f
	  	end

			ac = AberturaCaixa.find(self.abertura_caixa_id)

				Financa.create(
 					cod_proc:        self.abertura_caixa_id,
					sigla_proc:      'FCS',
					controle_caixa: self.abertura_caixa_id,
	        tabela:        'FECHAMENTO_CAIXAS',
	        tabela_id:     self.id,
	        data:          ac.data,
	        diferido:   	 ac.data,
	        cheque_status: 0,
	        estado:        0,
	        status:        1,
	        conta_id:      self.conta_origem_id,
	        moeda:         self.moeda,
	        saida_dolar:   var_us.to_f,
	      	saida_guarani: var_gs.to_f,
	    		saida_real:    var_rs.to_f,
	    		saida_peso:    var_ps.to_f,
	    		forma_pago_id: 17,
	    		documento_numero: self.abertura_caixa_id.to_s,
	      	concepto:      self.obs
	      )

				Financa.create(
 					cod_proc:        self.abertura_caixa_id,
					sigla_proc:      'FCS',
					controle_caixa: self.abertura_caixa_id,
	        tabela:        'FECHAMENTO_CAIXAS',
	        tabela_id:     self.id,
	        data:          ac.data,
	        diferido:   	 ac.data,
	        cheque_status: 0,
	        estado:        0,
	        status:        1,
	        conta_id:      self.conta_destino_id,
	        moeda:         self.moeda,
	        entrada_dolar:   var_us.to_f,
	      	entrada_guarani: var_gs.to_f,
	    		entrada_real:    var_rs.to_f,
	    		entrada_peso:    var_ps.to_f,
	    		forma_pago_id: 17,
	    		documento_numero: self.abertura_caixa_id.to_s,
	      	concepto:      self.obs
	      )

		end
	end

	def send_forma_pago_efetivo
		if self.forma_pago_id == 1

	    if self.moeda.to_i == 0
	      var_us = self.valor.to_f
	      var_gs = 0
	      var_rs = 0
	      var_ps = 0

	      var_sis_us = self.valor_sis.to_f
	      var_sis_gs = 0
	      var_sis_rs = 0
	      var_sis_ps = 0
	    elsif self.moeda.to_i == 1
	      var_us = 0
	      var_gs = self.valor.to_f
	      var_rs = 0
	      var_ps = 0

	      var_sis_us = 0
	      var_sis_gs = self.valor_sis.to_f
	      var_sis_rs = 0
	      var_sis_ps = 0
	  	elsif self.moeda.to_i == 2
	      var_us = 0
	      var_gs = 0
	      var_rs = self.valor.to_f
	      var_ps = 0

	      var_sis_us = 0
	      var_sis_gs = 0
	      var_sis_rs = self.valor_sis.to_f
	      var_sis_ps = 0
	  	elsif self.moeda.to_i == 3
	      var_us = 0
	      var_gs = 0
	      var_rs = 0
	      var_ps = self.valor.to_f

	      var_sis_us = 0
	      var_sis_gs = 0
	      var_sis_rs = 0
	      var_sis_ps = self.valor_sis.to_f
	  	end


				Financa.create(
 					cod_proc:        fechamento_caixa.id,
					sigla_proc:      'FCS',
					controle_caixa: fechamento_caixa.abertura_caixa_id,
	        tabela:        'FECHAMENTO_CAIXAS',
	        tabela_id:     self.id,
	        data:          fechamento_caixa.abertura_caixa.data,
	        diferido:   	 fechamento_caixa.abertura_caixa.data,
	        cheque_status: 0,
	        estado:        0,
	        status:        1,
	        conta_id:      self.conta_origem_id,
	        moeda:         self.moeda,
	        saida_dolar:   var_us.to_f,
	      	saida_guarani: var_gs.to_f,
	    		saida_real:    var_rs.to_f,
	    		saida_peso:    var_ps.to_f,
	    		forma_pago_id: 1,
	      	concepto:      "TRANSF. SALDO CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
	      )

				Financa.create(
					cod_proc:        fechamento_caixa.id,
					sigla_proc:      'FCS',
					controle_caixa: fechamento_caixa.abertura_caixa_id,
	        tabela:          'FECHAMENTO_CAIXAS',
	        tabela_id:       self.id,
	        data:            fechamento_caixa.abertura_caixa.data,
	        diferido:   		 fechamento_caixa.abertura_caixa.data,
	        cheque_status:   0,
	        estado:          0,
	        status:          1,
	        conta_id:        self.conta_destino_id,
	        moeda:           self.moeda,
	        forma_pago_id:   1,
	        entrada_dolar:   var_us.to_f,
	      	entrada_guarani: var_gs.to_f,
	    		entrada_real:    var_rs.to_f,
	    		entrada_peso:    var_ps.to_f,
	      	concepto:        "TRANSF. SALDO CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
	      )


		end
	end

	def transfere_valores
		if self.valor.to_f > 0
			Financa.destroy_all("tabela = 'FECHAMENTO_CAIXAS' and tabela_id = #{self.id} " )
	    if self.moeda.to_i == 0
	      var_us = self.valor.to_f
	      var_gs = 0
	      var_rs = 0
	      var_ps = 0

	      var_sis_us = self.valor_sis.to_f
	      var_sis_gs = 0
	      var_sis_rs = 0
	      var_sis_ps = 0
	    elsif self.moeda.to_i == 1
	      var_us = 0
	      var_gs = self.valor.to_f
	      var_rs = 0
	      var_ps = 0

	      var_sis_us = 0
	      var_sis_gs = self.valor_sis.to_f
	      var_sis_rs = 0
	      var_sis_ps = 0
	  	elsif self.moeda.to_i == 2
	      var_us = 0
	      var_gs = 0
	      var_rs = self.valor.to_f
	      var_ps = 0

	      var_sis_us = 0
	      var_sis_gs = 0
	      var_sis_rs = self.valor_sis.to_f
	      var_sis_ps = 0
	  	elsif self.moeda.to_i == 3
	      var_us = 0
	      var_gs = 0
	      var_rs = 0
	      var_ps = self.valor.to_f

	      var_sis_us = 0
	      var_sis_gs = 0
	      var_sis_rs = 0
	      var_sis_ps = self.valor_sis.to_f
	  	end


			if self.forma_pago_id.to_i == 1 #transf saldo caixa

				Financa.create(
					cod_proc:        fechamento_caixa.id,
					sigla_proc:      'FC',
					controle_caixa: fechamento_caixa.abertura_caixa_id,
	        tabela:        'FECHAMENTO_CAIXAS',
	        tabela_id:     self.id,
	        data:          fechamento_caixa.data,
	        diferido:   	 fechamento_caixa.data,
	        cheque_status: 0,
	        estado:        0,
	        status:        1,
	        conta_id:      self.conta_origem_id,
	        moeda:         self.moeda,
	        saida_dolar:   var_us.to_f,
	      	saida_guarani: var_gs.to_f,
	    		saida_real:    var_rs.to_f,
	    		saida_peso:    var_ps.to_f,
	      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
	      )

				Financa.create(
					cod_proc:        fechamento_caixa.id,
					sigla_proc:      'FC',
					controle_caixa: fechamento_caixa.abertura_caixa_id,
	        tabela:          'FECHAMENTO_CAIXAS',
	        tabela_id:       self.id,
	        data:            fechamento_caixa.data,
	        diferido:   		 fechamento_caixa.data,
	        cheque_status:   0,
	        estado:          0,
	        status:          1,
	        conta_id:        self.conta_destino_id,
	        moeda:           self.moeda,
	        entrada_dolar:   var_us.to_f,
	      	entrada_guarani: var_gs.to_f,
	    		entrada_real:    var_rs.to_f,
	    		entrada_peso:    var_ps.to_f,
	      	concepto:        "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
	      )

        if self.valor.to_f != self.valor_sis.to_f
        	if self.valor_sis.to_f > self.valor.to_f
						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							controle_caixa: fechamento_caixa.abertura_caixa_id,
			        tabela:          'FECHAMENTO_CAIXAS',
			        tabela_id:       self.id,
			        data:            fechamento_caixa.data,
			        diferido:   		 fechamento_caixa.data,
			        cheque_status:   0,
			        estado:          0,
			        status:          1,
			        conta_id:        Conta.last(:conditions => ["nome = 'SOBRANTE FALTANTE CAJA' AND unidade_id = #{fechamento_caixa.unidade_id}"]).id,
			        moeda:           self.moeda,
			        saida_dolar:     var_sis_us.to_f - var_us.to_f,
			      	saida_guarani:   var_sis_gs.to_f - var_gs.to_f,
			    		saida_real:      var_sis_rs.to_f - var_rs.to_f,
			    		saida_peso:      var_sis_ps.to_f - var_ps.to_f,
			      	concepto:        "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
			      )
					end

        	if self.valor.to_f > self.valor_sis.to_f
						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							controle_caixa: fechamento_caixa.abertura_caixa_id,
			        tabela:          'FECHAMENTO_CAIXAS',
			        tabela_id:       self.id,
			        data:            fechamento_caixa.data,
			        diferido:   		 fechamento_caixa.data,
			        cheque_status:   0,
			        estado:          0,
			        status:          1,
			        conta_id:        Conta.last(:conditions => ["nome = 'SOBRANTE FALTANTE CAJA' AND unidade_id = #{fechamento_caixa.unidade_id}"]).id,
			        moeda:           self.moeda,
			        entrada_dolar:     var_us.to_f - var_sis_us.to_f,
			      	entrada_guarani:   var_gs.to_f - var_sis_gs.to_f,
			    		entrada_real:      var_rs.to_f - var_sis_rs.to_f,
			    		entrada_peso:      var_ps.to_f - var_sis_ps.to_f,
			      	concepto:        "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
			      )
					end
				end
			#PAGO ANTECIPADO
			elsif self.forma_pago_id.to_i == 16

				Financa.create(
					cod_proc:        fechamento_caixa.id,
					sigla_proc:      'FC',
					controle_caixa: fechamento_caixa.abertura_caixa_id,
	        tabela:        'FECHAMENTO_CAIXAS',
	        tabela_id:     self.id,
	        data:          fechamento_caixa.data,
	        diferido:   	 fechamento_caixa.data,
	        cheque_status: 0,
	        estado:        0,
	        status:        1,
	        conta_id:      self.conta_origem_id,
	        moeda:         self.moeda,
	        saida_dolar:   var_us.to_f,
	      	saida_guarani: var_gs.to_f,
	    		saida_real:    var_rs.to_f,
	    		saida_peso:    var_ps.to_f,
	      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
	      )

				Financa.create(
					cod_proc:        fechamento_caixa.id,
					sigla_proc:      'FC',
					controle_caixa: fechamento_caixa.abertura_caixa_id,
	        tabela:          'FECHAMENTO_CAIXAS',
	        tabela_id:       self.id,
	        data:            fechamento_caixa.data,
	        diferido:   		 fechamento_caixa.data,
	        cheque_status:   0,
	        estado:          0,
	        status:          1,
	        conta_id:        self.conta_destino_id,
	        moeda:           self.moeda,
	        entrada_dolar:   var_us.to_f,
	      	entrada_guarani: var_gs.to_f,
	    		entrada_real:    var_rs.to_f,
	    		entrada_peso:    var_ps.to_f,
	      	concepto:        "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
	      )


	    #transfere giro
			elsif self.forma_pago_id.to_i == 18
				#vendas
				lista_cartao = VendasFinanca.joins(:venda).where("vendas.controle_caixa = #{fechamento_caixa.abertura_caixa_id} and vendas_financas.forma_pago_id = 18")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end

				#cobros
				lista_cartao = CobrosFinanca.joins(:cobro).where("cobros.terminal_id = #{fechamento_caixa.abertura_caixa.terminal_id} and cobros.data = '#{fechamento_caixa.abertura_caixa.data}' and cobros_financas.forma_pago_id = 18")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end


	    #transfere  cartao credito
			elsif self.forma_pago_id.to_i == 3
				#vendas
				lista_cartao = VendasFinanca.joins(:venda).where("vendas.controle_caixa = #{fechamento_caixa.abertura_caixa_id} and vendas_financas.forma_pago_id = 3  AND vendas_financas.cartao_bandeira_id = #{self.cartao_bandeira_id}")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end

				#cobros
				lista_cartao = CobrosFinanca.joins(:cobro).where("cobros.terminal_id = #{fechamento_caixa.abertura_caixa.terminal_id} and cobros.data = '#{fechamento_caixa.abertura_caixa.data}' and cobros_financas.forma_pago_id = 3 AND cobros_financas.cartao_bandeira_id = #{self.cartao_bandeira_id}")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end


	    #transfere  cartao credito
			elsif self.forma_pago_id.to_i == 4
				#vendas

				lista_cartao = VendasFinanca.joins(:venda).where("vendas.controle_caixa = #{fechamento_caixa.abertura_caixa_id} and vendas_financas.forma_pago_id = 4  AND vendas_financas.cartao_bandeira_id = #{self.cartao_bandeira_id}")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end

      	#cobros
				lista_cartao = CobrosFinanca.joins(:cobro).where("cobros.terminal_id = #{fechamento_caixa.abertura_caixa.terminal_id} and cobros.data = '#{fechamento_caixa.abertura_caixa.data}' AND cobros_financas.forma_pago_id = 4 AND cobros_financas.cartao_bandeira_id = #{self.cartao_bandeira_id}")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cartao_bandeira_id: lc.cartao_bandeira_id,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end

	    #transfere  TRANS. BANCARIA
			elsif self.forma_pago_id.to_i == 15
				#vendas

				lista_cartao = VendasFinanca.joins(:venda).where("vendas.controle_caixa = #{fechamento_caixa.abertura_caixa_id} and vendas_financas.forma_pago_id = 15")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF BANCARIA #{lc.persona_nome} CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF BANCARIA #{lc.persona_nome} CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end

      	#cobros
				lista_cartao = CobrosFinanca.joins(:cobro).where("cobros.terminal_id = #{fechamento_caixa.abertura_caixa.terminal_id} and cobros.data = '#{fechamento_caixa.abertura_caixa.data}' AND cobros_financas.forma_pago_id = 15")
				lista_cartao.each do |lc|
					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:     self.id,
		        data:          fechamento_caixa.data,
		        diferido:   	 fechamento_caixa.data,
		        cheque_status: 0,
		        estado:        0,
		        status:        1,
		        conta_id:      self.conta_origem_id,
		        moeda:         self.moeda,
		        saida_dolar:   lc.valor_dolar.to_f,
		      	saida_guarani: lc.valor_guarani.to_f,
		    		saida_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF BANCARIA #{lc.persona_nome} CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )

					Financa.create(
						cod_proc:        fechamento_caixa.id,
						sigla_proc:      'FC',
						documento_numero: lc.nr_comprovante,
						controle_caixa: fechamento_caixa.abertura_caixa_id,
		        tabela:          'FECHAMENTO_CAIXAS',
		        tabela_id:       self.id,
		        data:            fechamento_caixa.data,
		        diferido:   		 fechamento_caixa.data,
		        cheque_status:   0,
		        estado:          0,
		        status:          1,
		        conta_id:        self.conta_destino_id,
		        moeda:           self.moeda,
		        entrada_dolar:   lc.valor_dolar.to_f,
		      	entrada_guarani: lc.valor_guarani.to_f,
		    		entrada_real:    lc.valor_real.to_f,
		      	concepto:      "TRANSF BANCARIA #{lc.persona_nome} CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
		      )
	      end

				#transfere cheque ao dia
				elsif self.forma_pago_id.to_i == 5
					#vendas
					lista_cartao = VendasFinanca.joins(:venda).where("vendas.controle_caixa = #{fechamento_caixa.abertura_caixa_id} and vendas_financas.forma_pago_id = 5")
					lista_cartao.each do |lc|
						ch = Financa.where(cheque: lc.cheque, conta_id: self.conta_origem_id)

						ch.each do |c|
							c.update_attributes(cheque_status: 2)
						end

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:     self.id,
							data:          lc.data,
							diferido:   	 fechamento_caixa.data,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:        lc.cheque,
							titular:       lc.titular,
							banco:         lc.banco,
							cheque_status: 2,
							estado:        0,
							status:        0,
							conta_id:      self.conta_origem_id,
							moeda:         self.moeda,
							saida_dolar:   lc.valor_dolar.to_f,
							saida_guarani: lc.valor_guarani.to_f,
							saida_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:       self.id,
							data:            lc.data,
							diferido:   		 fechamento_caixa.data,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:          lc.cheque,
							titular:       lc.titular,
							banco:         lc.banco,
							cheque_status:   1,
							estado:          0,
							status:          0,
							conta_id:        self.conta_destino_id,
							moeda:           self.moeda,
							entrada_dolar:   lc.valor_dolar.to_f,
							entrada_guarani: lc.valor_guarani.to_f,
							entrada_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)
					end

          #cobro
					lista_cartao = CobrosFinanca.joins(:cobro).where("cobros.terminal_id = #{fechamento_caixa.abertura_caixa.terminal_id} and cobros.data = '#{fechamento_caixa.abertura_caixa.data}' and cobros_financas.forma_pago_id = 5")
					lista_cartao.each do |lc|
						ch = Financa.where(cheque: lc.cheque, conta_id: self.conta_origem_id)

						ch.each do |c|
							c.update_attributes(cheque_status: 2)
						end

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:     self.id,
							data:          lc.data,
							diferido:   	 fechamento_caixa.data,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:        lc.cheque,
							titular:       lc.titular,
							banco:         lc.banco,
							cheque_status: 2,
							estado:        0,
							status:        0,
							conta_id:      self.conta_origem_id,
							moeda:         self.moeda,
							saida_dolar:   lc.valor_dolar.to_f,
							saida_guarani: lc.valor_guarani.to_f,
							saida_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:       self.id,
							data:            lc.data,
							diferido:   		 fechamento_caixa.data,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:          lc.cheque,
							titular:       lc.titular,
							banco:         lc.banco,
							cheque_status:   1,
							estado:          0,
							status:          0,
							conta_id:        self.conta_destino_id,
							moeda:           self.moeda,
							entrada_dolar:   lc.valor_dolar.to_f,
							entrada_guarani: lc.valor_guarani.to_f,
							entrada_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)
					end


				#transfere cheque diferido
				elsif self.forma_pago_id.to_i == 6
					#vendas
					lista_cartao = VendasFinanca.joins(:venda).where("vendas.controle_caixa = #{fechamento_caixa.abertura_caixa_id} and vendas_financas.forma_pago_id = 6")
					lista_cartao.each do |lc|
						ch = Financa.where(cheque: lc.cheque, conta_id: self.conta_origem_id)

						ch.each do |c|
							c.update_attributes(cheque_status: 2)
						end

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:     self.id,
							data:          lc.data,
							diferido:   	 lc.diferido,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:        lc.cheque,
							cheque_status: 2,
							estado:        0,
							status:        0,
							conta_id:      self.conta_origem_id,
							moeda:         self.moeda,
							saida_dolar:   lc.valor_dolar.to_f,
							saida_guarani: lc.valor_guarani.to_f,
							saida_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:       self.id,
							data:            lc.data,
							diferido:   		 lc.diferido,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:          lc.cheque,
							cheque_status:   1,
							estado:          0,
							status:          0,
							conta_id:        self.conta_destino_id,
							moeda:           self.moeda,
							entrada_dolar:   lc.valor_dolar.to_f,
							entrada_guarani: lc.valor_guarani.to_f,
							entrada_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)
					end

					#cobros
					lista_cartao = CobrosFinanca.joins(:cobro).where("cobros.terminal_id = #{fechamento_caixa.abertura_caixa.terminal_id} and cobros.data = '#{fechamento_caixa.abertura_caixa.data}' and cobros_financas.forma_pago_id = 6")
					lista_cartao.each do |lc|
						ch = Financa.where(cheque: lc.cheque, conta_id: self.conta_origem_id)

						ch.each do |c|
							c.update_attributes(cheque_status: 2)
						end

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:     self.id,
							data:          lc.data,
							diferido:   	 lc.diferido,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:        lc.cheque,
							cheque_status: 2,
							estado:        0,
							status:        0,
							conta_id:      self.conta_origem_id,
							moeda:         self.moeda,
							saida_dolar:   lc.valor_dolar.to_f,
							saida_guarani: lc.valor_guarani.to_f,
							saida_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)

						Financa.create(
							cod_proc:        fechamento_caixa.id,
							sigla_proc:      'FC',
							documento_numero: lc.nr_comprovante,
							controle_caixa: fechamento_caixa.abertura_caixa_id,
							tabela:          'FECHAMENTO_CAIXAS',
							tabela_id:       self.id,
							data:            lc.data,
							diferido:   		 lc.diferido,
							cartao_bandeira_id: lc.cartao_bandeira_id,
							cheque:          lc.cheque,
							cheque_status:   1,
							estado:          0,
							status:          0,
							conta_id:        self.conta_destino_id,
							moeda:           self.moeda,
							entrada_dolar:   lc.valor_dolar.to_f,
							entrada_guarani: lc.valor_guarani.to_f,
							entrada_real:    lc.valor_real.to_f,
							concepto:      "TRANSF. CIERRE DE CAJA " << fechamento_caixa.abertura_caixa_id.to_s << " RESPONSABLE " << fechamento_caixa.abertura_caixa.usuario.usuario_nome
						)
					end

			end
		end
	end
end

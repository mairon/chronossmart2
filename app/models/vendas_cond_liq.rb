class VendasCondLiq < ActiveRecord::Base
	belongs_to :venda
	belongs_to :cond_liq

	before_save :get_os
	before_destroy :update_os

	def get_os


		sql = " SELECT CP.PRODUTO_ID,
                    MAX(CP.ID) AS ID,
                    MAX(CP.DEPOSITO_ID) AS DEPOSITO_ID,
                    MAX(CP.VALOR_GS) AS VALOR_GS,
                    MAX(CP.VALOR_US) AS VALOR_US,
                    SUM(CP.QUANTIDADE) AS SAIDA,
                    coalesce((SELECT SUM(CE.QUANTIDADE) FROM CONDICIONAL_PRODUTOS CE WHERE CE.PRODUTO_ID = CP.PRODUTO_ID AND CE.STATUS = FALSE AND CE.CONDICIONAL_ID = #{self.condicional_id}),0) AS ENTRADA
      FROM CONDICIONAL_PRODUTOS CP
      INNER JOIN PRODUTOS P
      ON P.ID = CP.PRODUTO_ID
      WHERE CP.CONDICIONAL_ID = #{self.condicional_id}
      AND CP.STATUS = TRUE
      GROUP BY 1
      HAVING
      (SUM(CP.QUANTIDADE) - coalesce((SELECT SUM(CE.QUANTIDADE) FROM CONDICIONAL_PRODUTOS CE WHERE CE.PRODUTO_ID = CP.PRODUTO_ID AND CE.STATUS = FALSE AND CE.CONDICIONAL_ID = #{self.condicional_id}),0)) > 0"



		CondicionalProduto.find_by_sql(sql).each do |os|
      puts "=================>>>>>>>   #{os.produto_id }"
      puts "=================>>>>>>>   #{saldo = (os.saida.to_i - os.entrada.to_i) }"

        Stock.where( tabela: 'VENDAS_COND_LIQ', tabela_id: os.id).destroy_all


          #entra para sair no stock
          Stock.create( :venda_id         => venda.id,
                              :tabela => 'VENDAS_COND_LIQ',
                              :tabela_id => os.id,
                              :cod_processo => self.condicional_id,
                              :sigla_proc => 'VCL',
                              :persona_id       => venda.persona_id,
                              :persona_nome     => venda.persona_nome,
                              :data             => venda.data,
                              :status           => 4,
                              :deposito_id      => os.deposito_id,
                              :unitario_guarani => os.valor_gs,
                              :unitario_dolar   => os.valor_us,
                              :entrada          => saldo.to_f,
                              :saida            => 0,
                              :produto_id       => os.produto_id,
                              :produto_nome     => os.produto.nome)

					VendasProduto.create( :venda_id         => venda.id,
                              :persona_id       => venda.persona_id,
                              :data             => venda.data,
                              :moeda            => venda.moeda,
                              :cotacao          => venda.cotacao,
                              :deposito_id      => os.deposito_id,
                              :promedio_guarani => os.valor_gs,
                              :promedio_dolar   => os.valor_us,
                              :quantidade       => saldo.to_f,
                              :unitario_dolar   => os.valor_us.to_f,
                              :preco_dolar      => os.valor_us.to_f,
                              :total_dolar      => (saldo.to_f * os.valor_us.to_f),
                              :unitario_guarani => os.valor_gs.to_f,
                              :preco_guarani    => os.valor_gs.to_f,
                              :total_guarani    => (saldo.to_f * os.valor_gs.to_f),
                              :produto_id       => os.produto_id,
                              :produto_nome     => os.produto.nome)

		end

		cd = Condicional.find(self.condicional_id)
		cd.update_attributes(status: 1)
	end

	def update_os
		os = Condicional.find(self.condicional_id)
    Stock.where( tabela: 'VENDAS_COND_LIQ', cod_processo: self.condicional_id).destroy_all
		os.update_attributes(status: 0)		
	end


end

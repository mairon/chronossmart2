class FechamentoCaixa < ActiveRecord::Base
	has_many :fechamento_caixa_dts, order: 1, dependent: :destroy
  belongs_to :abertura_caixa
  belongs_to :usuario
  belongs_to :turno
  belongs_to :cartao_bandeira
  before_create :atualiza_status_caixa
	
  def atualiza_status_caixa
		sql = "SELECT V.ID,
					       V.CONTROLE_CAIXA,
					       v.usuario_id
					FROM VENDAS V
					WHERE (SELECT COUNT(Vf.ID) FROM VENDAS_financas Vf WHERE Vf.VENDA_ID = V.ID ) = 0
					AND V.CONTROLE_CAIXA = #{self.abertura_caixa_id}"
		vendas_incompletas = Financa.find_by_sql(sql)
		vendas_incompletas.each do |vi|
			Venda.destroy_all("id = #{vi.id}" )
		end
	end

	def self.gera_valores(params)

    sql_ef = "
            SELECT FORMA_PAGO_ID, 
            MOEDA, 
            CONTA_ID,
            SUM(ENTRADA_GUARANI - SAIDA_GUARANI) VALOR_GS,
            SUM(ENTRADA_DOLAR - SAIDA_DOLAR) VALOR_US,
            SUM(ENTRADA_REAL - SAIDA_REAL) VALOR_RS
            FROM FINANCAS 
            WHERE CONTROLE_CAIXA = #{params[:abertura_caixa_id]}
            AND FORMA_PAGO_ID IN (1,8)
            AND MOEDA = 1
            GROUP BY 1,2,3
          "
    efetivo = Venda.find_by_sql(sql_ef)


    saldo = 0 
    conta_id = 0 
		efetivo.each do |v|
    	saldo += v.valor_gs.to_f
      conta_id = v.conta_id
		end

    saldo_inicial = AberturaCaixa.find(params[:abertura_caixa_id])

    FechamentoCaixaDt.create(  
        :fechamento_caixa_id => params[:id],
        :forma_pago_id       => 1,
        :moeda               => 1,
        :cartao_bandeira_id  => 0,
        :valor_sis           => saldo_inicial.saldo_gs.to_f + saldo.to_f,
        :conta_origem_id     => conta_id
      )


    #CREDITO
    sql_cred = "
            SELECT FORMA_PAGO_ID, 
            MOEDA, 
            CONTA_ID,
            SUM(VALOR_GUARANI) AS VALOR_GS,
            SUM(VALOR_DOLAR) AS VALOR_US,
            SUM(VALOR_REAL) AS VALOR_RS
            FROM VENDAS_FINANCAS 
            WHERE CONTROLE_CAIXA = #{params[:abertura_caixa_id]}
            AND FORMA_PAGO_ID = 2
            GROUP BY 1,2,3
          "
    credito = Venda.find_by_sql(sql_cred)


    saldo = 0 
    conta_id = 0 
    credito.each do |v|
      saldo += v.valor_gs.to_f
      conta_id = v.conta_id
    end

    saldo_inicial = AberturaCaixa.find(params[:abertura_caixa_id])

    FechamentoCaixaDt.create(  
        :fechamento_caixa_id => params[:id],
        :forma_pago_id       => 2,
        :moeda               => 1,
        :cartao_bandeira_id  => 0,
        :valor_sis           => saldo.to_f,
        :conta_origem_id     => conta_id
      )


    #diferente e efetivo guarani e vuelto
    sql_otros = "
            SELECT FORMA_PAGO_ID, 
            MOEDA, 
            CONTA_ID,
            SUM(ENTRADA_GUARANI - SAIDA_GUARANI) VALOR_GS,
            SUM(ENTRADA_DOLAR - SAIDA_DOLAR) VALOR_US,
            SUM(ENTRADA_REAL - SAIDA_REAL) VALOR_RS
            FROM FINANCAS 
            WHERE CONTROLE_CAIXA = #{params[:abertura_caixa_id]}
            AND FORMA_PAGO_ID NOT IN (8)
            GROUP BY 1,2,3
          "
    otros = Venda.find_by_sql(sql_otros)


    otros.each do |v|
      if v.moeda == 0
        valor = v.valor_us.to_f
      elsif v.moeda == 1
        valor = v.valor_gs.to_f
      elsif v.moeda == 2
        valor = v.valor_rs.to_f
      end

      if (v.moeda.to_i and v.forma_pago_id.to_i ) != 1
        FechamentoCaixaDt.create(  
          :fechamento_caixa_id => params[:id],
          :forma_pago_id       => v.forma_pago_id,
          :moeda               => v.moeda,
          :cartao_bandeira_id  => 0,
          :valor_sis           => valor.to_f,
          :conta_origem_id     => v.conta_id
        )
      end
    end

	end	
end



class Cobraca < ActiveRecord::Base

  	def self.list_contas(cobraca)
      sql = "
      SELECT P.ID,
            P.NOME,
            P.TELEFONE,
            (SELECT SUM(DIVIDA_DOLAR - COBRO_DOLAR) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{cobraca.vencimento}' AND MOEDA = 0) AS VENCIDA_US,
            (SELECT SUM(DIVIDA_GUARANI - COBRO_GUARANI) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO  <= '#{cobraca.vencimento}' AND MOEDA = 1) AS VENCIDA_GS,
            (SELECT SUM(DIVIDA_REAL - COBRO_REAL) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{cobraca.vencimento}' AND MOEDA = 2) AS VENCIDA_RS,
            (SELECT MIN(VENCIMENTO) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO  <= '#{cobraca.vencimento}') AS VENCIDO_DESDE
     FROM  PERSONAS P 
     WHERE
           ( (SELECT COALESCE(SUM(DIVIDA_DOLAR - COBRO_DOLAR),0) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO  <= '#{cobraca.vencimento}' AND MOEDA = 0) +
           (SELECT COALESCE(SUM(DIVIDA_DOLAR - COBRO_DOLAR),0) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{cobraca.vencimento}' AND MOEDA = 0)) > 0                     
           ORDER BY 2"

			Cobraca.find_by_sql(sql)                     
  	end
end

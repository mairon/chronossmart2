class DevChequeProv < ActiveRecord::Base
	has_many :dev_cheque_prov_dts, dependent: :destroy
	belongs_to :persona
	belongs_to :conta
  	validates :cotacao, :cotacao_real, :persona_id, :conta_id, presence: true
	validates :cotacao, :cotacao_real, numericality:  { :greater_than => 0 }
	before_save :calc

	def calc
		c = Conta.find_by_id(self.conta_id)
		self.moeda = c.moeda		
	end

	def self.lista_cheques(persona_id,moeda, conta_id)
		if moeda.to_i == 0
			saldo = "COALESCE(F.SAIDA_DOLAR,0) - COALESCE(f.ENTRADA_DOLAR,0)"
		else
			saldo = "COALESCE(F.SAIDA_GUARANI,0) - COALESCE(f.ENTRADA_GUARANI,0)"
		end

		sql = "SELECT
							F.CHEQUE,
							MAX(F.BANCO) AS BANCO,
							MAX(F.PERSONA_NOME) AS TITULAR,
							MAX(F.CONCEPTO) AS CONCEPTO,
							MAX(F.DATA) AS DATA,
							MAX(F.DIFERIDO) AS DIFERIDO,
							SUM(F.SAIDA_GUARANI) AS TOTAL_GS,
							SUM(F.SAIDA_DOLAR) AS TOTAL_US,
							MAX(F.COD_PROC) AS COD_PROC,
							MAX(F.SIGLA_PROC) AS SIGLA_PROC,
							MAX(F.ID) AS ID
					FROM FINANCAS F
  				WHERE F.CONTA_ID = #{conta_id} AND F.PERSONA_ID = #{persona_id} AND F.MOEDA = #{moeda} AND CHEQUE <> ''
  				AND F.ESTADO = 0 
  				GROUP BY 1
  				HAVING 
  					SUM(#{saldo}) > 0
  				ORDER BY 1,5 desc"
		Financa.find_by_sql(sql)
	end
end

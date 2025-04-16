class DevChequeCliente < ActiveRecord::Base
	has_many :dev_cheque_cliente_dts, dependent: :destroy
	belongs_to :persona
	belongs_to :motivos_dev_cheque
	belongs_to :conta
  validates :cotacao, :cotacao_real, :persona_id, :conta_id, presence: true
	validates :cotacao, :cotacao_real, numericality:  { :greater_than => 0 }
	before_save :finds


	def finds
		mdc = MotivosDevCheque.find(self.motivos_dev_cheque_id)
		self.deb_cli = mdc.deb_cli_prov

		ct = Conta.find(self.conta_id)
		self.moeda = ct.moeda
	end
	def self.lista_cheques(persona_id,moeda, conta_id)
		sql = "SELECT
									F.CHEQUE,
									MAX(F.BANCO) AS BANCO,
									MAX(F.TITULAR) AS TITULAR,
									MAX(F.CONCEPTO) AS CONCEPTO,
									MAX(F.DATA) AS DATA,
									MAX(F.DIFERIDO) AS DIFERIDO,
									SUM(F.ENTRADA_GUARANI) AS TOTAL_GS,
									SUM(F.ENTRADA_DOLAR) AS TOTAL_US,
									MAX(F.COD_PROC) AS COD_PROC,
									MAX(F.SIGLA_PROC) AS SIGLA_PROC,
									MAX(F.ID) AS ID
					FROM FINANCAS F
  				WHERE F.STATUS = 0 AND F.CONTA_ID = #{conta_id} AND F.PERSONA_ID = #{persona_id} AND F.MOEDA = 1 AND CHEQUE_STATUS <> 0
  				GROUP BY 1
  				HAVING 
  					SUM(F.ENTRADA_GUARANI - f.SAIDA_GUARANI) > 0
  				ORDER BY 1,5 desc"
		Financa.find_by_sql(sql)
	end
end
class Retencao < ActiveRecord::Base
	has_many :retencao_docs,  dependent: :destroy
	belongs_to :persona
  validates :cotacao, :numericality => { :greater_than => 0.01 }
  validates :unidade_id, numericality: { only_integer: true }

def self.faturas(params)
	sql ="SELECT
							PD.PERSONA_ID,
							PD.DATA,
							PD.MOEDA,
							PD.DOCUMENTO_NOME,
							PD.DOCUMENTO_NUMERO_01,
							PD.DOCUMENTO_NUMERO_02,
							PD.DOCUMENTO_NUMERO,
							C.UNIDADE_ID,
							CF.COTA AS COTA,
							CF.VALOR_GUARANI AS VALOR_GS,
							CF.VALOR_DOLAR AS VALOR_US,
							(PD.GRAVADAS_10_DOLAR + PD.GRAVADAS_05_DOLAR) AS GRAV_US,
							(PD.IMPOSTO_05_DOLAR + PD.IMPOSTO_10_DOLAR) AS IMP_US,
							(PD.GRAVADAS_10_GUARANI + PD.GRAVADAS_05_GUARANI) AS GRAV_GS,
							(PD.IMPOSTO_05_GUARANI + PD.IMPOSTO_10_GUARANI) AS IMP_GS
				FROM COMPRAS_FINANCAS CF
				INNER JOIN COMPRAS_DOCUMENTOS PD
				ON CF.COMPRA_ID = PD.COMPRA_ID
				INNER JOIN COMPRAS C
				ON C.ID = PD.COMPRA_ID
				WHERE C.UNIDADE_ID = #{params[:unidade]} AND PD.PERSONA_ID = #{params[:persona]}
				AND (SELECT COUNT(RD.ID) FROM RETENCAO_DOCS RD WHERE RD.COTA = CF.COTA AND RD.PERSONA_ID = PD.PERSONA_ID AND RD.DOCUMENTO_NUMERO_01 = PD.DOCUMENTO_NUMERO_01 AND RD.DOCUMENTO_NUMERO_02 = PD.DOCUMENTO_NUMERO_02 AND RD.DOCUMENTO_NUMERO = PD.DOCUMENTO_NUMERO ) = 0
				ORDER BY  2,7"

	Retencao.find_by_sql(sql)
	end


end

class PlanoDeConta < ActiveRecord::Base

  validates_presence_of :codigo,
                        :descricao

  validates_uniqueness_of :codigo

  def self.find_recent
    all(:select => 'id,codigo,descricao',:order => 'codigo')
  end

  def self.list_classificao
    sql = "SELECT PC.ID,
                     (PG.DESCRICAO || ' > ' || PC.DESCRICAO) AS DESCRICAO
              FROM PLANO_DE_CONTAS PC
              LEFT JOIN PLANO_DE_CONTAS PG
              ON SUBSTRING(PG.CODIGO, 1, 8) = SUBSTRING(PC.CODIGO, 1, 8)
              WHERE LENGTH(PC.CODIGO) >=12 AND LENGTH(PG.CODIGO) =8
              ORDER BY 2"

    PlanoDeConta.find_by_sql(sql)
  end
end

class AvaliacaoFunc < ActiveRecord::Base
  has_many :avaliacao_func_refs, :dependent => :destroy
  belongs_to :persona
  belongs_to :avaliacao_ref
  validates_uniqueness_of :persona_id, scope: [:periodo], message: " ja cadastrado."
  after_create :gera_avalicacao

  def gera_avalicacao
    ar = AvaliacaoRef.all

    ar.each do |a|

      sql = "SELECT SUM(M.SCORE) AS SCORE
      FROM SOLICITUDES S

      INNER JOIN USUARIOS U
      ON U.ID = S.USUARIO_ID

      INNER JOIN MOTIVOS M
      ON M.ID = S.MOTIVO_ID
      WHERE date_part('month', S.DATA ) = '#{self.periodo.strftime("%m")}'
      AND  date_part('YEAR', S.DATA ) = '#{self.periodo.strftime("%Y")}'
      AND U.PERSONA_ID = #{self.persona_id}
      AND M.AVALIACAO_REF_ID = #{a.id}"

      m = Motivo.find_by_sql(sql)


      if m[0].score.to_i == 0
        nt = 10
      else
        nt = (10 + m[0].score.to_i)
      end

      AvaliacaoFuncRef.create(
        avaliacao_ref_id: a.id,
        avaliacao_func_id: self.id,
        nota: nt.to_i
      )
    end
  end

end



class AjustePreco < ActiveRecord::Base
  has_many :ajuste_preco_detalhes, :order => 1, :dependent => :destroy
	belongs_to :sub_grupo
	belongs_to :grupo
	validates :porcen_1, :numericality =>  { :greater_than => 0 }

	after_create :add_produtos

	def add_produtos
		cole = "P.COLECAO_ID = #self.colecao_id}" unless self.colecao_id.blank?
    sql ="SELECT
                 P.ID,
                 P.FABRICANTE_COD,
                 P.NOME,
                 TP.PRECO_1_US,
                 TP.PRECO_1_GS,
                 TP.PRECO_1_RS,
                 TP.PRECO_2_US,
                 TP.PRECO_2_GS,
                 TP.PRECO_2_RS,
                 TP.PRECO_3_US,
                 TP.PRECO_3_GS,
                 TP.PRECO_3_RS,
                 TP.PRECO_4_US,
                 TP.PRECO_4_GS,
                 TP.PRECO_4_RS

          FROM PRODUTOS_TABELA_PRECOS TP
          INNER JOIN PRODUTOS P
          ON TP.PRODUTO_ID = P.ID
          WHERE TP.UNIDADE_ID = #{self.unidade_id}
          AND P.SUB_GRUPO_ID = #{self.sub_grupo_id}
          AND TP.PRECO_1_US > 0
          "
   produtos = ProdutosTabelaPreco.find_by_sql(sql)

   produtos.each do |p|
        AjustePrecoDetalhe.create(  :ajuste_preco_id => self.id,
                               :produto_id    => p.id,
                               :unidade_id    => self.unidade_id.to_i,
                               :preco_1_us    => p.preco_1_us,
                               :preco_1_gs    => p.preco_1_gs,
                               :preco_1_rs    => p.preco_1_rs,
                               :porcen_1      => self.porcen_1,
                               :preco_2_us    => p.preco_2_us,
                               :preco_2_gs    => p.preco_2_gs,
                               :preco_2_rs    => p.preco_2_rs,
                               :porcen_2      => self.porcen_2,
                               :preco_3_us    => p.preco_3_us,
                               :preco_3_gs    => p.preco_3_gs,
                               :preco_3_rs    => p.preco_3_rs,
                               :porcen_3      => self.porcen_3,
                               :preco_4_us    => p.preco_4_us,
                               :preco_4_gs    => p.preco_4_gs,
                               :preco_4_rs    => p.preco_4_rs,
                               :porcen_4      => self.porcen_4,
                               :tipo          => self.tipo,
                               :status        => 0,
                               :data          => self.data

                               )
   end
	end

end

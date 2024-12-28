class ProdutosGrade < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.produto_id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	belongs_to :produto
	belongs_to :cor
	belongs_to :tamanho
	has_many :produto_barras, :order => 1, :dependent => :destroy
	has_many :produtos_custos, :order => 1, :dependent => :destroy
  has_many :compras_produtos, dependent: :restrict
  has_many :vendas_produtos, dependent: :restrict
  has_many :presupuesto_produtos, dependent: :restrict
  has_many :pedido_compra_produtos, dependent: :restrict

	validates :barra, uniqueness: { scope: :produto_id, message: "codigo ja esta em uso." }, allow_blank: true
	validates_presence_of :produto_id, :cor_id, :tamanho_id

  after_create :custo_medio_por_unidade

  def custo_medio_por_unidade
    unidade_list = Deposito.all

    unidade_list.each do |ul|
      ProdutosCusto.create( :deposito_id => ul.id,
                            :unidade_id => ul.unidade_id,
                            :produto_id => self.produto_id,
                            :produtos_grade_id => self.id)
    end
  end

end

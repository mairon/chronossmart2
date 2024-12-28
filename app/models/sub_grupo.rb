class SubGrupo < ActiveRecord::Base
    belongs_to :persona
    has_many :produtos, dependent: :restrict
    has_many :sub_grupo_precos,   :order => 1, :dependent => :destroy
    has_many :produtos, dependent: :restrict
    validates_presence_of :descricao
    validates_uniqueness_of :descricao


	after_create :gera_tabela


	def gera_tabela
    unis = Unidade.all
    unis.each do |u|
      tp = TabelaPreco.all
      tp.each do |t|
      SubGrupoPreco.create( :sub_grupo_id     => self.id,
                            :unidade_id       =>  u.id,
                            :tabela_preco_id  =>  t.id
                          )
      end
    end
	end
end

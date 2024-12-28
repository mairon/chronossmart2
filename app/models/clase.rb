class Clase < ActiveRecord::Base
	has_many :clase_tabela_preco

  validates_presence_of :descricao
  validates_uniqueness_of :descricao

  after_create :gera_tabela_de_preco

	def gera_tabela_de_preco
    ClaseTabelaPreco.destroy_all("clase_id = #{self.id}")
    unidade = Unidade.all
    tabela = TabelaPreco.all
    unidade.each do |u|
      tabela.each do |t|
        #gera preco tabela preco
        ClaseTabelaPreco.create( :clase_id       => self.id,
                                    :unidade_id       => u.id.to_i,
                                    :tabela_preco_id  => t.id.to_i
                               )

      end
    end
  end
end

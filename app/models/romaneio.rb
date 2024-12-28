class Romaneio < ActiveRecord::Base
  belongs_to :contrato
  has_many :romaneio_produtos,    order: 1, dependent: :destroy

  after_create :get_produtos_remicao



  def get_produtos_remicao

    ncp = NotaRemicaoProduto.where(nota_remicao_id: self.nota_remicao_id)

    ncp.each do |p|
      RomaneioProduto.create(
        romaneio_id: self.id,
        produto_id: p.produto_id,
        produto_nome: p.produto_nome,
        quantidade: p.quantidade,
        tara: p.tara,
        bruto: p.bruto
      )
    end
  end
end

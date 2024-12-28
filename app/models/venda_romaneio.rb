class VendaRomaneio < ActiveRecord::Base
  belongs_to :venda
  belongs_to :romaneio

  after_destroy :update_produtos

  def update_produtos
    VendasProduto.where(venda_id: self.venda_id).destroy_all
    v  = Venda.find(self.venda_id)
    vr = VendaRomaneio.where(venda_id: self.venda_id)
    if vr.count(:id) > 0
      rp = RomaneioProduto.where("romaneio_id in (#{vr.map  { |t| t.romaneio_id }.join(', ')})")

      VendasProduto.create( :venda_id         => v.id,
                              :persona_id       => v.persona_id,
                              :data             => v.data,
                              :moeda            => v.moeda,
                              :cotacao          => v.cotacao,
                              :quantidade             => rp.sum(:quantidade).to_f,
                              :unitario_dolar         => 0,
                              :preco_dolar            => 0,
                              :total_dolar            => 0,
                              :unitario_guarani       => (rp.sum(:total_guarani).to_f / rp.sum(:quantidade).to_f),
                              :preco_guarani          => (rp.sum(:total_guarani).to_f / rp.sum(:quantidade).to_f),
                              :total_guarani          => rp.sum(:total_guarani).to_f,
                              :produto_id             => rp.last.produto_id,
                              :produto_nome           => rp.last.produto_nome,

                            )

      end
  end
end

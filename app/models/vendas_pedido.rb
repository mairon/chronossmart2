class VendasPedido < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.venda_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :presupuesto
  belongs_to :venda

  before_save :get_os
  before_destroy :update_os

  def get_os
    presupuesto.presupuesto_produtos.each do |os|
          VendasProduto.create( :venda_id         => venda.id,
                                :presupuesto_id => os.presupuesto_id,
                                :presupuesto_produto_id => os.id,
                              :persona_id       => venda.persona_id,
                              :data             => venda.data,
                              :moeda            => venda.moeda,
                              :cotacao          => venda.cotacao,
                              :deposito_id      => 1,
                              :promedio_guarani => os.unitario_guarani,
                              :promedio_dolar   => os.unitario_dolar,
                              :quantidade       => os.quantidade,
                              :unitario_dolar   => os.unitario_dolar.to_f,
                              :preco_dolar      => os.unitario_dolar.to_f,
                              :total_dolar      => os.total_dolar.to_f,
                              :unitario_guarani => os.unitario_guarani.to_f,
                              :preco_guarani    => os.unitario_guarani.to_f,
                              :total_guarani    => os.total_guarani,
                              :unitario_real => os.unitario_real.to_f,
                              :preco_real    => os.unitario_real.to_f,
                              :total_real    => os.total_real,
                              :produto_id       => os.produto_id,
                              :produto_nome     => os.produto.nome)

    end
    os = Presupuesto.find(self.presupuesto_id)
    os.update_attributes(status: 3)
  end

  def update_os
    os = Presupuesto.find(self.presupuesto_id)
    VendasProduto.where( presupuesto_id: self.presupuesto_id).destroy_all
    os.update_attributes(status: 0)
  end

end

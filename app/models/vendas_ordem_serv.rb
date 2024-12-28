class VendasOrdemServ < ActiveRecord::Base
      belongs_to :venda
      belongs_to :ordem_serv

      before_save :get_os
      before_destroy :update_os

      def get_os
            ordem_serv.ordem_serv_prods.each do |os|
                  retirado =  OrdemServProd.where(status: false, ordem_serv_id: ordem_serv.id, produto_id: os.produto_id).sum(:quantidade)
      saldo = (os.quantidade.to_i - retirado.to_i)

          #entra para sair no stock
          Stock.create( :venda_id         => venda.id,
                              :tabela => 'ORDEM_SERV_VENDA',
                              :tabela_id => os.id,
                              :cod_processo => os.ordem_serv_id,
                              :sigla_proc => 'CDV',
                              :persona_id       => venda.persona_id,
                              :persona_nome       => venda.persona_nome,
                              :data             => venda.data,
                              :status             => 4,
                              :deposito_id      => 1,
                              :unitario_guarani       => os.valor_gs,
                              :unitario_dolar         => os.valor_us,
                              :entrada                  => saldo.to_f,
                              :saida                  => 0,
                              :produto_id             => os.produto_id,
                              :produto_nome           => os.produto.nome)

                              VendasProduto.create( :venda_id         => venda.id,
                              :persona_id       => venda.persona_id,
                              :data             => venda.data,
                              :moeda            => venda.moeda,
                              :cotacao          => venda.cotacao,
                              :deposito_id      => 1,
                              :promedio_guarani       => os.valor_gs,
                              :promedio_dolar         => os.valor_us,
                              :quantidade             => saldo.to_f,
                              :unitario_dolar         => os.valor_us.to_f,
                              :preco_dolar            => os.valor_us.to_f,
                              :total_dolar            => (saldo.to_f * os.valor_us.to_f),
                              :unitario_guarani         => os.valor_gs.to_f,
                              :preco_guarani            => os.valor_gs.to_f,
                              :total_guarani            => (saldo.to_f * os.valor_gs.to_f),
                              :produto_id             => os.produto_id,
                              :produto_nome           => os.produto.nome)

            end
            os = OrdemServ.find(self.ordem_serv_id)
            os.update_attributes(status: 'BAJADO')
      end

      def update_os
            os = OrdemServ.find(self.ordem_serv_id)
            os.update_attributes(status: 'PENDIENTE')
      end


end

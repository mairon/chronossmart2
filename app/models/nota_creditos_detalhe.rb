class NotaCreditosDetalhe < ActiveRecord::Base
    belongs_to :nota_credito
    validates :produto_id, :quantidade, :moeda, :presence => true
    belongs_to :produto


      def before_save
          vend                = Venda.find_by_id( self.venda_id );
          self.vendedor_id    = vend.vendedor_id unless self.venda_id.blank? ;
          self.vendedor_nome  = vend.vendedor_nome.to_s unless self.venda_id.blank? ;
      end
end

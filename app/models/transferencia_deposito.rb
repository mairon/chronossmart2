class TransferenciaDeposito < ActiveRecord::Base
  has_many :transferencia_deposito_detalhes, order: 'id desc', :dependent => :destroy   
  validates_presence_of :unidade_origem_id, :unidade_destino_id, :deposito_origem_id, :deposito_destino_id

  before_save :calcs
  #after_create :atribu_produtos_compra
  def calcs
    ingreso = Deposito.find_by_id(self.deposito_origem_id);
    self.deposito_origem_nome = ingreso.nome.to_s;

    destino = Deposito.find_by_id(self.deposito_destino_id);
    self.deposito_destino_nome = destino.nome.to_s;
  end

  def atribu_produtos_compra
  	if self.compra_id != 0
  		TransferenciaDepositoDetalhe.destroy_all("transferencia_deposito_id = #{self.id}" )

  		get_compra = ComprasProduto.where("compra_id = #{self.compra_id}")
  		get_compra.each do |gt|
      TransferenciaDepositoDetalhe.create( produto_id: gt.produto_id,
                            transferencia_deposito_id: self.id,
                            deposito_origem_id: self.deposito_origem_id,
                            deposito_destino_id: self.deposito_destino_id,
                            quantidade: gt.quantidade,
                            data: self.data
                            )

  		end
  	end
  end
end

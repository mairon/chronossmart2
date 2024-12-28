class NotaCreditoProveedorProduto < ActiveRecord::Base
  belongs_to :nota_credito_proveedor

  validates_presence_of :produto_id, :quantidade
  before_save :calcs

  def calcs
  	if nota_credito_proveedor.moeda.to_i == 0
      self.total_dolar = self.unitario_dolar * self.quantidade
  		self.unitario_guarani = self.unitario_dolar.to_f * nota_credito_proveedor.cotacao.to_f
  		self.total_guarani = self.total_dolar.to_f * nota_credito_proveedor.cotacao.to_f

  		self.unitario_real = self.unitario_guarani.to_f / nota_credito_proveedor.cotacao_real.to_f
  		self.total_real = self.total_guarani.to_f / nota_credito_proveedor.cotacao_real.to_f

  	elsif nota_credito_proveedor.moeda.to_i == 1
      self.total_guarani = self.unitario_guarani.to_f * self.quantidade.to_f
  		self.unitario_dolar = self.unitario_guarani.to_f / nota_credito_proveedor.cotacao.to_f
  		self.total_dolar = self.total_guarani.to_f / nota_credito_proveedor.cotacao.to_f

  		self.unitario_real = self.unitario_guarani.to_f / nota_credito_proveedor.cotacao_real.to_f
  		self.total_real = self.total_guarani.to_f / nota_credito_proveedor.cotacao_real.to_f

  	else
      self.total_real = self.unitario_real * self.quantidade
  		self.unitario_guarani = self.unitario_real.to_f * nota_credito_proveedor.cotacao_real.to_f
  		self.total_guarani = self.total_real.to_f * nota_credito_proveedor.cotacao_real.to_f
  		self.unitario_dolar = self.unitario_guarani.to_f / nota_credito_proveedor.cotacao.to_f
  		self.total_dolar = self.total_guarani.to_f / nota_credito_proveedor.cotacao.to_f

  	end
  end

end

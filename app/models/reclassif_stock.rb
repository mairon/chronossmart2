class ReclassifStock < ActiveRecord::Base



    def self.filtro_rs(params)                                         #
    
        cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?
        
        if params[:tipo] == "CODIGO"
          tipo = "id"
          cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
        elsif params[:tipo] == "PRODUCTO"
          tipo = "produto_nome"
          cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
        end

        ReclassifStock.paginate( :conditions => cond,
                                 :page       => params[:page],
                                 :per_page   => 25,
                                 :order      => 'data desc,id desc')
    end
  before_save :finds
	def finds
        produto = Produto.find_by_id(self.produto_id)
        self.produto_nome = produto.nome.to_s
    		self.clase_id     = produto.clase_id.to_s
    		self.grupo_id     = produto.grupo_id.to_s

        deposito = Deposito.find_by_id(self.deposito_id);
        self.deposito_nome = deposito.nome.to_s unless self.deposito_id.blank?;		

        #ultimo quantidade
        stock = Stock.sum('entrada - saida', :conditions => ["produto_id = ? AND data <= ? AND TABELA <> 'RECLASSIF_STOCK'",self.produto_id, self.data])
        self.ant_quantidade = stock.to_f
        #ultimo entrada
        cust = Stock.last( :conditions => ["status = 0 and produto_id = ? AND data <= ? AND TABELA <> 'RECLASSIF_STOCK'",self.produto_id, self.data], :order => 'data')
		    self.custo_dolar   = cust.unitario_dolar
		    self.custo_guarani = cust.unitario_guarani

        self.ant_custo_dolar   = cust.unitario_dolar
        self.ant_custo_guarani = cust.unitario_guarani

	end
end

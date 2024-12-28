class EntradaSaidaFunc < ActiveRecord::Base
  has_many :entrada_saida_func_detalhes,   :order => 1, :dependent => :destroy


  def self.filtro(params)                                         #
    
    cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?
    
    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
    elsif params[:tipo] == "DOCUMENTO"
      tipo = "documento_numero "
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
    elsif params[:tipo] == "CLIENTE"
      tipo = "produto_nome"
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?

    end



    self.paginate( :select => 'id,data,produto_nome',
                    :conditions => cond,
                    :page       => params[:page],
                    :per_page   => 25,
                    :order      => 'data desc,id desc')
  end


  def before_save

    res = Persona.find_by_id(self.responsavel_id);
    self.responsavel_nome = res.nome.to_s unless self.responsavel_id.blank?

    pd = Produto.find_by_id(self.produto_id);
    self.produto_nome = pd.nome.to_s unless self.produto_id.blank?
    self.ob_ref = pd.fabricante_cod.to_s unless self.produto_id.blank?
  end  

end

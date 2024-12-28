class Fatura < ActiveRecord::Base

validates_length_of   :documento_numero_01,
    :documento_numero_02, :maximum=>3,:message => "Tiene mas Numero do que lo permitido"

    validates_uniqueness_of :documento_numero  , :scope=>[:documento_numero_01, :documento_numero_02, :persona_id], :message => " ja cadastrado."

    validates_presence_of :cotacao,
    :persona_id,
    :documento_numero_01,
    :documento_numero_02,
    :documento_numero



  def self.filtro(params)                                         #
    
    cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?
    
    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
    elsif params[:tipo] == "DOCUMENTO"
      tipo = "documento_numero"
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
    else
      tipo = "persona_nome"
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?

    end
    
    self.all(:conditions => cond,:order => 'data,documento_numero_01,documento_numero_02,documento_numero')
  end

  def before_save                                                        #
      @persona = Persona.find_by_id(self.persona_id);
      self.persona_nome = @persona.nome.to_s unless  self.persona_id.blank?
  end

end

class NotaCredito < ActiveRecord::Base

  audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :nota_creditos_detalhes,   :order => 1, :dependent => :destroy
  has_many :nota_creditos_docs,   :order => 1, :dependent => :destroy
  belongs_to :persona

  before_save :finds
  def self.filtro_nc(params)                                         #
    unidade = params[:unidade]
    unless params[:inicio].blank?
    cond = ["unidade_id = #{unidade} and data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "]
    else
      cond = ["unidade_id = #{unidade}"]
    end
    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["unidade_id = #{unidade} and #{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
    elsif params[:tipo] == "DOCUMENTO"
      tipo = "documento_numero "
      cond =  ["unidade_id = #{unidade} and #{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
    elsif params[:tipo] == "CLIENTE"
      tipo = "persona_nome"
      cond =  ["unidade_id = #{unidade} and #{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?

    end

    NotaCredito.paginate( :select => 'id,data,persona_nome,operacao,documento_numero,documento_numero_01,documento_numero_02',
                    :conditions => cond,
                    :page       => params[:page],
                    :per_page   => 25,
                    :order      => 'data desc,id desc')
  end


    def finds
      s = FormFiscal.find_by_id(self.documento_id);
      self.documento_numero_01 = s.doc_01.to_s unless self.documento_id.blank?
      self.documento_numero_02 = s.doc_02.to_s unless self.documento_id.blank?
      self.documento_numero = s.doc.to_s unless self.documento_id.blank?

    end

end

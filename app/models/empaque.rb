class Empaque < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
	has_many :empaque_produtos, :order => 'id desc', :dependent => :destroy
	belongs_to :persona
	belongs_to :venda

	validates :persona_id, :venda_id, :presence => true
  validates :venda_id, :numericality =>  { :greater_than => 0 }
  validates_uniqueness_of :venda_id
	validate :valida_venda

	def valida_venda
	  saldo = Venda.count('id',:conditions => ["id = ? and persona_id = ?",self.venda_id,self.persona_id])
    if ( saldo.to_i == 0 )
      errors[:base] << ( "Numero de Venta Incorreto, o no existe!" )
    end
	end

	def finds
	  trans = Persona.find_by_id(self.trans_id);
    self.trans_nome = trans.nome.to_s unless self.trans_id.blank?

	  resp = Persona.find_by_id(self.responsavel_id);
    self.trans_nome = resp.nome.to_s unless self.responsavel_id.blank?
	end

  def self.filtro(params)
    unidade = "unidade_id = #{params[:unidade]}"
    envio = "AND ENVIADO = #{params[:env]}" unless params[:env].blank?
    unless params[:inicio].blank?
      cond =  "#{unidade} #{envio} AND data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    else
      cond =  "#{unidade} #{envio}"
    end
    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  "#{unidade} #{envio} AND #{tipo} = ? ","#{params[:busca]}" unless params[:busca].blank?
    elsif params[:tipo] == "VENTA"
      tipo = "venda_id"
      cond =  "#{unidade} #{envio} AND #{tipo} = ? ","#{params[:busca]}" unless params[:busca].blank?
    elsif params[:tipo] == "CLIENTE"
    	find_per = Persona.where("nome ILIKE '%#{params[:busca]}%'")
    	if find_per.last.id != nil
    		busca_persona = "AND persona_id = #{find_per.last.id}"
	    else
	    	busca_persona = ""
	    end
      cond = "#{unidade} #{busca_persona} #{envio}" unless params[:busca].blank?
    end

    Empaque.all( :conditions => cond,
    	              :limit   => 200,
                    :order   => 'data desc,id desc')
  end

end

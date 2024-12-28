class Analize < ActiveRecord::Base
	validates_presence_of :qtd_coletas
	has_many :analize_amostras, :order => 'amostra', :dependent => :destroy
	has_many :analizes_financas, :dependent => :destroy
	has_many :analize_ensaios, :dependent => :destroy
	has_many :revisao_results
	belongs_to :tipo

	before_save :finds

 	validates  :qtd_coletas, :tipo_id, :solicitude, :presence => true

 	validates_uniqueness_of :solicitude, :scope => [:tipo_id, :cultura_id], :message => " ja cadastrado."

	def finds
	  t = Tipo.find_by_id(self.tipo_id)
	  self.tipo_nome = t.nome.to_s unless self.tipo_id.blank?

	  e = Persona.find_by_id(self.empresa_id)
	  self.empresa_nome = e.nome.to_s unless self.empresa_id.blank?
	  self.persona_id = self.empresa_id

	  # previsao de entrega
	  if self.entrega == 48
	  	self.prev_entrega = self.data + 2
	  elsif self.entrega == 72
	  	self.prev_entrega = self.data + 3
	  elsif self.entrega == 96
	  	self.prev_entrega = self.data + 4
	  elsif self.entrega == 120
	  	self.prev_entrega = self.data + 5

	  end


	end

def self.filtro(params)

			tipo = " AND A.TIPO_ID = #{params[:busca_t]}" unless params[:busca_t].blank?
			data = "AND A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' " unless params[:inicio].blank?

	    if params[:tipo] == "CODIGO"
	      cond =  "WHERE A.ID = #{params[:busca]} #{tipo} #{data}"
	    elsif params[:tipo] == "CLIENTE"
	      cond =  "WHERE A.EMPRESA_NOME LIKE '%#{params[:busca]}%' #{tipo} #{data}"
	    end

    sql = "SELECT A.ID,
               A.DATA,
               A.EMPRESA_NOME,
               A.EMPRESA_ID,
               A.TIPO_NOME,
               A.SOLICITUDE,
               A.QTD_COLETAS,
               A.STATUS,
               (SELECT AA.AMOSTRA FROM ANALIZE_AMOSTRAS AA WHERE AA.ANALIZE_ID = A.ID ORDER BY ID LIMIT 1   ) AS PRIMEIRA_AMOSTRA,
               (SELECT AA.AMOSTRA FROM ANALIZE_AMOSTRAS AA WHERE AA.ANALIZE_ID = A.ID ORDER BY ID  DESC LIMIT 1 ) AS ULTIMA_AMOSTRA
        FROM
        ANALIZES A
        #{cond}
        ORDER BY 2 desc, 6 desc"
    @analizes = Analize.find_by_sql(sql)
  end
end

class EntradaResult < ActiveRecord::Base
	has_many :entrada_result_ensaios, :dependent => :destroy
	belongs_to :tipo
	belongs_to :metodo

  validates :metodo_id,
  					:tipo_id,
  					:amostra_inicio,
  					:amostra_final,
            :presence => true

  validates :amostra_inicio, :amostra_final, :numericality =>  { :greater_than => 0 }


	before_save :finds
	def finds
      self.tipo_leitura = metodo.tipo_leitura
	  	m = Metodo.find_by_id(self.metodo_id)
	  	self.metodo_nome = m.nome

	  	f = Prova.find_by_metodo_id(self.metodo_id, :conditions => ["prova = 'FATOR'"])
	  	self.prova_valor = f.valor

	  	d = Prova.find_by_metodo_id(self.metodo_id, :conditions => ["prova = 'DILUICION'"])
	  	self.diluicao = d.valor

	  	p = Prova.find_by_metodo_id(self.metodo_id, :conditions => ["prova = 'PB'"])
	  	self.pb = p.valor

	end
	def self.filtro(params)
		if params[:filtro] == '0'
			met = "AND A.METODO_ID = #{params[:metodo]}" unless params[:metodo].blank?

    	cond = "WHERE A.TIPO_ID = #{params[:busca_t]} #{met}" unless params[:busca_t].blank?

    elsif params[:filtro] == '1'
    	cond = "WHERE A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' " unless params[:inicio].blank?
    end
    sql = "SELECT A.ID,
               A.DATA,
               A.TIPO_ID,
               A.METODO_ID,
               A.METODO_NOME,
               A.AMOSTRA_INICIO,
               A.AMOSTRA_FINAL
        FROM
        ENTRADA_RESULTS A
        #{cond}
        ORDER BY 4 desc, 1 desc, 2 desc"
    EntradaResult.find_by_sql(sql)
  end

end

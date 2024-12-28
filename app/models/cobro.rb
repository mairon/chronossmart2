class Cobro < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :cobros_detalhes,   :order => 'id desc', :dependent => :destroy
  has_many :cobros_adelantos,  :order => 'id desc', :dependent => :destroy
  has_many :cobros_financas,   :order => 'id', :dependent => :destroy
  has_many :cobros_ncs,   :order => 'id desc'
  belongs_to :persona

  validates_presence_of :cotacao,:persona_nome,:persona_id

  validates :cotacao, :cotacao_real, :cotacao_rs_us, numericality:  { :greater_than => 0 }

  def self.filtro(params)
    unidade = "C.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      data = "AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "C.ID"
        cond = "AND #{tipo} = #{params[:busca]} "
      else
        tipo = "C.PERSONA_NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT C.ID,
                  C.DATA,
                  C.MOEDA,
                  C.PERSONA_NOME,
                  C.USUARIO_CREATED,
                  U.USUARIO_NOME,
                  (SELECT SUM(CD.COBRO_GUARANI) FROM COBROS_DETALHES CD WHERE CD.COBRO_ID = C.ID ) AS VALOR_GS,
                  (SELECT SUM(CD.COBRO_DOLAR) FROM COBROS_DETALHES CD WHERE CD.COBRO_ID = C.ID ) AS VALOR_US,
                  (SELECT SUM(CD.COBRO_REAL) FROM COBROS_DETALHES CD WHERE CD.COBRO_ID = C.ID ) AS VALOR_RS,
                  (SELECT CF.descricao FROM COBROS_FINANCAS CF WHERE CF.COBRO_ID = C.ID LIMIT 1 ) AS DESCRICAO,
                  (SELECT CF.CONTA_NOME FROM COBROS_FINANCAS CF WHERE CF.COBRO_ID = C.ID LIMIT 1 ) AS CONTA_NOME,
                  BF.STATUS AS STATUS_BLOCK
            FROM COBROS C
            LEFT JOIN USUARIOS U
            ON C.USUARIO_CREATED = U.ID
            LEFT JOIN BLOCK_FINANCEIROS BF
            ON date_part('month', C.DATA) = date_part('month', BF.PERIODO) 
            AND date_part('year', C.DATA) = date_part('year', BF.PERIODO)
          WHERE #{unidade} #{data} #{cond}
          ORDER BY C.DATA DESC, C.ID DESC
          "
    Cobro.paginate_by_sql(sql, page: params[:page], :per_page => 25)
  end

  def cancela_adelanto
    @persona          = Persona.find_by_id(self.vendedor_id);
    self.vendedor_nome = @persona.nome.to_s unless self.vendedor_id.blank? 

    if self.adelanto == 1 and self.adelanto_id != 0
        Cliente.destroy_all("tabela = 'COBROS' AND tabela_id = #{self.id}" )
        ad = AdelantoCota.first(:conditions => ["adelanto_id = ?", self.adelanto_id])
        if ad.status == 0

          Cliente.create( :tabela_id           => self.id.to_i,
                          :tabela              => 'COBROS',
                          :vencimento          => ad.data,
                          :persona_id          => ad.persona_id,
                          :persona_nome        => ad.persona_nome,
                          :moeda               => ad.moeda,
                          :documento_numero    => ad.documento_numero,
                          :cota                => 1,
                          :data                => ad.data,
                          :divida_dolar        => ad.valor_us.to_f,
                          :divida_guarani      => ad.valor_gs.to_f,
                          :liquidacao          => 1,
                          :tipo                => '1',
                          :unidade_id          => self.unidade_id,
                          :documento_numero_01 => '000',
                          :documento_numero_02 => '000')
        else
          Cliente.create( :tabela_id           => self.id.to_i,
                          :tabela              => 'COBROS',
                          :vencimento          => ad.data,
                          :persona_id          => ad.persona_id,
                          :persona_nome        => ad.persona_nome,
                          :moeda               => ad.moeda,
                          :documento_numero    => ad.documento_numero,
                          :cota                => 1,
                          :unidade_id          => self.unidade_id,
                          :data                => ad.data,
                          :cobro_dolar        => ad.valor_us.to_f,
                          :cobro_guarani      => ad.valor_gs.to_f,
                          :liquidacao          => 1,
                          :tipo                => '1',
                          :documento_numero_01 => '000',
                          :documento_numero_02 => '000')
        end
        cl_liqui = Cliente.all(:conditions => ["tabela = 'ADELANTOS' AND tabela_id = ?",self.adelanto_id])
        
        cl_liqui.each do |lq|
          lq.update_attribute :liquidacao, 1
        end
    end
  end
end

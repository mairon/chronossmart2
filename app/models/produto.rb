class Produto < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :produto_composicao, :order => 1, :dependent => :destroy
  has_many :produto_barras, :order => 1, :dependent => :destroy
  has_many :produto_imagens, :order => 1, :dependent => :destroy
  has_many :produtos_tabela_preco, :order => 'id', :dependent => :destroy

  has_many :compras_produtos, dependent: :restrict
  has_many :vendas_produtos, dependent: :restrict
  has_many :presupuesto_produtos, dependent: :restrict
  has_many :pedido_compra_produtos, dependent: :restrict
  has_many :produtos_tabela_precos, dependent: :restrict
  accepts_nested_attributes_for :produtos_tabela_precos, :allow_destroy => true

  belongs_to :grupo, select: 'id,descricao'
  belongs_to :clase, select: 'id,descricao,max_desc'
  belongs_to :sub_grupo, select: 'id,descricao'
  belongs_to :unidade_medida

  has_attached_file :picture, :path => "#{Empresa.last.nome}/system/:attachment/:filename",
      :url => "#{Empresa.last.nome}/system/:attachment/:filename", default_url: 'default.jpg'

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/


  validates_presence_of :nome, :taxa, :clase_id
  validates_uniqueness_of :nome, scope: [:chassi], message: " ja cadastrado."
  validates_uniqueness_of :barra, :allow_blank => true, :allow_nil => true, message: " ja cadastrado."

  after_create :gera_tabela_de_preco
  before_save :gera_cod_barra_interno
  after_save :gera_cod_barra_id

  def gera_cod_barra_interno
    if self.barra == ''
      if Produto.last == nil
        self.barra = "89000"
      else
        self.barra = "88#{(Produto.last.id.to_i + 1).to_s}"
      end

    end
  end

  def gera_cod_barra_id

    ProdutoBarra.create( produto_id: self.id, barra: self.barra )

  end

  def self.busca_produto(params)
    clase     = "AND clase_id = #{params[:clase]}" unless params[:clase].blank?
    grupo     = "AND grupo_id = #{params[:grupo]}" unless params[:grupo].blank?
    sub_grupo = "AND sub_grupo_id = #{params[:sub_grupo]}" unless params[:sub_grupo].blank?
    data      = "AND created_at::date BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?

    params_search = "#{params[:busca].gsub(/\s/,':*&')}:*" unless params[:busca].blank?
    cond  = "AND to_tsvector(upper(COALESCE(NOME, '') || ' ' || COALESCE(CHASSI, '') || ' ' || COALESCE(REFERENCIA, '') || ' ' || COALESCE(COR, '') || ' ' ||  COALESCE(ANO, '') || ' ' ||  COALESCE(OBS, '') || ' ' || COALESCE(FABRICANTE_COD, '') || ' '  || ' ' || COALESCE(BARRA, '') || ' ' || COALESCE( CAST(ID AS CHARACTER VARYING ), '') )) @@ to_tsquery(upper('#{params_search}'))" unless params[:busca].blank?


    Produto.paginate(select: 'id,cor,chassi, ano, referencia, nome,clase_id,grupo_id,fabricante_cod,usuario_created, barra, preco_venda_guarani',
        conditions: ["id > 0 #{cond} #{data} #{clase} #{grupo} #{sub_grupo}"],page: params[:page],
        per_page: 10000).order('clase_id,grupo_id,nome').includes(:clase).includes(:grupo).includes(:sub_grupo)

  end

  def self.busca_produto_multiplo(params)
    clase = "clase_id = #{params[:filtro]["clase"]}" unless params[:filtro]["clase"].blank?
    tipo = "nome"            if params[:tipo] == "DESCRIPCION"
    tipo = "id"              if params[:tipo] == "CODIGO"
    tipo = "fabricante_cod"  if params[:tipo] == "REFERENCIA"

    if tipo == "id"
      cond  = " #{tipo} = #{params[:busca]} "
    else
      cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
    end

    Produto.all( :conditions =>  "#{clase}" ,:order => 'clase_id,grupo_id,nome')

  end

  def self.busca_produto_listado(params)

    clase     = "AND P.clase_id = #{params[:clase]}" unless params[:clase].blank?
    grupo     = "AND P.grupo_id = #{params[:grupo]}" unless params[:grupo].blank?
    sub_grupo = "AND P.sub_grupo_id = #{params[:sub_grupo]}" unless params[:sub_grupo].blank?
    colecao   = "AND P.colecao_id = #{params[:colecao]}" unless params[:colecao].blank?
    data      = "AND P.created_at::date BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?

    tipo = "P.nome"            if params[:tipo] == "DESCRIPCION"
    tipo = "P.id"              if params[:tipo] == "CODIGO"
    tipo = "P.fabricante_cod"  if params[:tipo] == "REFERENCIA"

    if tipo == "id"
      cond  = "AND #{tipo} = #{params[:busca]} "
    else
      params_search = "#{params[:busca].gsub(' ', '+')}:*" unless params[:busca].blank?
      cond  = "AND to_tsvector(upper(NOME)) @@ to_tsquery(upper('#{params_search}'))" unless params[:busca].blank?
    end

    sql = "SELECT
                  G.DESCRICAO AS GRUPO_NOME,
                  SG.DESCRICAO AS SUB_GRUPO_NOME,
                  P.ID,
                  P.NOME,
                  P.CLASE_ID,
                  P.GRUPO_ID,
                  P.FABRICANTE_COD,
                  P.USUARIO_CREATED,
                  P.OBS,
                  (SELECT SUM(ENTRADA - SAIDA) AS SUM_ID FROM STOCKS S WHERE S.PRODUTO_ID = P.ID AND S.DEPOSITO_ID = 22) AS STOCK
                  FROM PRODUTOS P
                  LEFT JOIN GRUPOS G
                  ON G.ID = P.GRUPO_ID
                  LEFT JOIN SUB_GRUPOS SG
                  ON SG.ID = P.SUB_GRUPO_ID
                  WHERE P.ID > 0 #{cond} #{data} #{clase} #{grupo} #{sub_grupo} #{colecao}
                  ORDER BY 1,2,4
                  "
    Produto.find_by_sql(sql)

  end

  def gera_tabela_de_preco
    ProdutosTabelaPreco.destroy_all("produto_id = #{self.id}")
    unidade = Unidade.all
    tabela = TabelaPreco.all
    unidade.each do |u|
      tabela.each do |t|
        #gera preco tabela preco
        ProdutosTabelaPreco.create( :produto_id       => self.id,
                                    :unidade_id       => u.id.to_i,
                                    :tabela_preco_id  => t.id.to_i
                               )

      end
    end
  end
end

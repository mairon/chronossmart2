class NotaRemicaosController < ApplicationController    
  before_filter :authenticate


  def detalhes_produtos_print
    @nota_remicao = NotaRemicao.find(params[:id])

    @nota_produtos = NotaRemicaoProduto.all(:conditions => ["nota_remicao_id = #{params[:id]}"])
    @qtd           = NotaRemicaoProduto.sum(:quantidade,:conditions => ["nota_remicao_id = #{params[:id]}"])

    render :layout => false
  end

  def comprovante
    @nota_remicao = NotaRemicao.find(params[:id])

    @nota_produtos = NotaRemicaoProduto.all(:conditions => ["nota_remicao_id = #{params[:id]}"])
    @qtd           = NotaRemicaoProduto.sum(:quantidade,:conditions => ["nota_remicao_id = #{params[:id]}"])        
    @custo_guarani = NotaRemicaoProduto.sum(:custo_guarani,:conditions => ["nota_remicao_id = #{params[:id]}"])        
    @valor_guarani = NotaRemicaoProduto.sum(:valor_guarani,:conditions => ["nota_remicao_id = #{params[:id]}"])

    render :layout => false
  end

  def index

    sql = ("SELECT NR.ID,
                   NR.DATA,
                   NR.DOCUMENTO_NUMERO_01,
                   NR.DOCUMENTO_NUMERO_02,
                   NR.DOCUMENTO_NUMERO,
                   NR.PERSONA_ID,
                   NR.PERSONA_NOME,
                   C.NOME AS CIDADE_NOME,
                   R.DOCUMENTO_NUMERO AS ROMANEIO_NUMERO,
                   CF.NOME AS CHOFER_NOME,
                   RC.PLACA AS CHAPA_C
                   
              FROM NOTA_REMICAOS NR

              LEFT JOIN CIDADES C
              ON C.ID = NR.CIDADE_ID

              LEFT JOIN PERSONAS CF
              ON CF.ID = NR.CHOFER_ID

              LEFT JOIN RODADOS RC
              ON RC.ID = NR.RODADO_CV_ID

              LEFT JOIN ROMANEIOS R
              ON R.NOTA_REMICAO_ID = NR.ID

              ORDER BY 1")
      @nota_remicaos = NotaRemicao.find_by_sql(sql)
      render layout: 'chart'
  end

  def show
    @nota_remicao = NotaRemicao.find(params[:id])
    @fts = FormFiscal.where("sigla_proc = 'NR' AND cod_proc = #{@nota_remicao.id} and status != 0 ").select("tipo_emissao, id, tot_gs, doc_01, doc_02, doc, status,cdc,terminal_id")
    render layout: 'chart'
  end

  def new
      @nota_remicao = NotaRemicao.new    
      render layout: 'chart'  
  end

  def edit
      @nota_remicao = NotaRemicao.find(params[:id])
  end
  
  def create
      @nota_remicao = NotaRemicao.new(params[:nota_remicao])
      @nota_remicao.usuario_created = current_user.usuario_nome
      @nota_remicao.unidade_created = current_unidade.unidade_nome

      respond_to do |format|
          if @nota_remicao.save
              format.html { redirect_to(@nota_remicao, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
              format.xml  { render :xml => @nota_remicao, :status => :created, :location => @nota_remicao }
          else
              format.html { render :action => "new" }
              format.xml  { render :xml => @nota_remicao.errors, :status => :unprocessable_entity }
          end
      end
  end

  def update
      @nota_remicao = NotaRemicao.find(params[:id])
      @nota_remicao.usuario_updated = current_user.usuario_nome
      @nota_remicao.unidade_updated = current_unidade.unidade_nome


      respond_to do |format|
          if @nota_remicao.update_attributes(params[:nota_remicao])
              format.html { redirect_to(@nota_remicao, :notice => t('SUCESSFUL_EDIT_MESSAGE')) }
              format.xml  { head :ok }
          else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @nota_remicao.errors, :status => :unprocessable_entity }
          end
      end
  end

  def destroy
      @nota_remicao = NotaRemicao.find(params[:id])
      @nota_remicao.destroy

      respond_to do |format|
          format.html { redirect_to(nota_remicaos_url) }
          format.xml  { head :ok }
      end
  end

end

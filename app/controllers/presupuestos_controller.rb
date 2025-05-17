class PresupuestosController < ApplicationController
  before_filter :authenticate

  def gera_cotas

    PresupuestoCota.destroy_all(presupuesto_id: params[:presupuesto_id])
    venc = 0
    cota = 1
    PresupuestoProduto.where(presupuesto_id: params[:presupuesto_id]).each do |pp|
      pp.cuotas.to_i.times do |c|
        PresupuestoCota.create(
          presupuesto_id: pp.presupuesto_id,
          centro_custo_id: pp.centro_custo_id,
          persona_id: pp.persona_id,
          produto_id: pp.produto_id,
          cuotas: cota,
          vencimento: pp.vencimento.to_date.months_since(venc.to_i),
          valor_gs: (  (pp.total_guarani.to_f - (pp.total_guarani.to_f * (pp.desconto.to_f / 100))) / pp.cuotas.to_i)
          )
        venc += 1
        cota += 1
      end
        venc = 0
        cota = 1
    end

    redirect_to presupuesto_path(params[:presupuesto_id])
  end

  def print_presupuesto
      @presupuesto = Presupuesto.find(params[:id])

    unless params[:grupos].blank?
      @presupuesto_produtos = PresupuestoProduto.joins(:produto).where("produtos.grupo_id in (#{params[:grupos].map  { |t| t }.join(', ')}) and presupuesto_produtos.presupuesto_id = #{@presupuesto.id}").order("produtos.grupo_id,presupuesto_produtos.id")      
    else
      @presupuesto_produtos = PresupuestoProduto.joins(:produto).where("presupuesto_produtos.presupuesto_id = #{@presupuesto.id}").order("produtos.grupo_id,presupuesto_produtos.id")
    end

    respond_to do |format|
          format.html do
            render  :pdf                    => "presupuesto-#{@presupuesto.id}",
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '0.20in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                    :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :spacing    => 19},
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "Chronos Software - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
  end

  def index
    @listas_cargas = ListaCarga.where(status: true).select('id,rodado_id,cidade_id').order('1')
  end

  def busca
    params[:unidade] = current_unidade.id
    @presupuestos = Presupuesto.filtro_busca(params)
    render :layout => false
  end

  def grade
    params[:unidade] = current_unidade.id
    @presupuesto = Presupuesto.find(params[:id])
    render :layout => 'consulta'
  end

  def resultado_grade
      @presupuesto = Presupuesto.find(params[:id])
      tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"
      tipo = "P.FABRICANTE_COD"  if params[:tipo] == "REFERENCIA"
      sql = "
      SELECT
             P.ID AS PRODUTO_ID,
             P.NOME AS NOME,
             P.FABRICANTE_COD,
             TB.PRECO_1_US,
             TB.PRECO_1_GS,
             TB.PRECO_1_RS
      FROM PRODUTOS P
      LEFT JOIN PRODUTOS_TABELA_PRECOS TB
      ON P.ID = TB.PRODUTO_ID
      WHERE TB.TABELA_PRECO_ID =1 AND TB.UNIDADE_ID = #{params[:unidade]} AND #{tipo} = '#{params[:busca]}'
      ORDER BY 2,3"
      @produtos = Produto.find_by_sql(sql)
      render :layout => 'consulta'
  end

  def add_produtos
    @presupuesto = Presupuesto.find(params[:id])

    params[:fields].each do |i, values|
      #elimina produtos conforme grade
      PresupuestoProduto.destroy_all("produtos_grade_id = #{values["produtos_grade_id"].to_i} and presupuesto_id = #{@presupuesto.id}")
      if values["quantidade"].to_i > 0
        #adiciona produtos
        PresupuestoProduto.create(
                            :presupuesto_id        => values["presupuesto_id"].to_i,
                            :produto_id            => values["produto_id"].to_i,
                            :produtos_grade_id     => values["produtos_grade_id"].to_i,
                            :quantidade            => values["quantidade"].to_i,
                            :fabricante_cod        => values["fabricante_cod"],
                            :clase_id              => values["clase_id"].to_i,
                            :grupo_id              => values["grupo_id"].to_i,
                            :sub_grupo_id          => values["sub_grupo_id"].to_i,
                            :cor_id                => values["cor_id"].to_i,
                            :cor_nome              => values["cor_nome"],
                            :tamanho_id            => values["tamanho_id"].to_i,
                            :tamanho_nome          => values["tamanho_nome"],
                            :produto_nome          => values["produto_nome"],
                            :cotacao               => values["cotacao"].to_f,
                            :data                  => values["data"],
                            :persona_nome          => values["persona_nome"],
                            :moeda                 => values["moeda"].to_i,
                            :unitario_dolar        => values["unitario_dolar"],
                            :total_dolar           => values["total_dolar"],
                            :unitario_real         => values["unitario_real"],
                            :total_real            => values["total_real"],
                            :unitario_guarani      => values["unitario_guarani"],
                            :total_guarani         => values["total_guarani"]
                            )
      end
    end
    redirect_to "/presupuestos/#{@presupuesto.id}"
  end

  def show
    @venda_config = VendasConfig.where(unidade_id: current_unidade.id).last
    @presupuesto = Presupuesto.find(params[:id])
    unless params[:grupos].blank?
      @presupuesto_produtos = PresupuestoProduto.joins(:produto).where("produtos.grupo_id in (#{params[:grupos].map  { |t| t }.join(', ')}) and presupuesto_produtos.presupuesto_id = #{@presupuesto.id}").order("produtos.grupo_id,presupuesto_produtos.id")      
    else
      @presupuesto_produtos = PresupuestoProduto.joins(:produto).where("presupuesto_produtos.presupuesto_id = #{@presupuesto.id}").order("produtos.grupo_id,presupuesto_produtos.id")
    end
    render layout: 'chart'
  end

  def new
      fields = CustomField.pluck(:internal_name)
      #store_accessor :custom_fields, [ fields ]

      @presupuesto = Presupuesto.new

      respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @presupuesto }
      end
  end

  def edit                      #
      @presupuesto = Presupuesto.find(params[:id])
  end

  def create                    #
      @presupuesto = Presupuesto.new(params[:presupuesto])
      @presupuesto.usuario_created = current_user.id
      @presupuesto.unidade_id      = current_unidade.id
      @presupuesto.status          = 0
      respond_to do |format|
          if @presupuesto.save
              format.html { redirect_to(@presupuesto) }
          else
              format.html { render :action => "new" }
          end
      end
  end

  def update                    #
      @presupuesto = Presupuesto.find(params[:id])

      respond_to do |format|
          if @presupuesto.update_attributes(params[:presupuesto])
              format.html { redirect_to(@presupuesto) }
          else
              format.html { render :action => "edit" }
          end
      end
  end

  def destroy                   #
      @presupuesto = Presupuesto.find(params[:id])
      @presupuesto.destroy

      respond_to do |format|
          format.html { redirect_to(presupuestos_url) }
      end
  end

  def presupuesto_dynamic_colecao
    @colecao = Colecao.find_all_by_sub_grupo_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

end

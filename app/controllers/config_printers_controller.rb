class ConfigPrintersController < ApplicationController


   def send_synchronize_data

    require 'net/http'

    pedidos = params[:pedidos].to_s unless params[:pedidos].blank?
    pedidos_produtos = params[:pedidos_produtos].to_s unless params[:pedidos_produtos].blank?
    visitas = params[:visitas].to_s unless params[:visitas].blank?

    ActiveRecord::Base.connection.execute(pedidos) unless pedidos.blank?
    ActiveRecord::Base.connection.execute(pedidos_produtos) unless pedidos_produtos.blank?
    ActiveRecord::Base.connection.execute(visitas) unless visitas.blank?

    return render :json => { :header => 'ok' }
  end


  def get_synchronize_data

    clientes = Persona.where("tipo_cliente = ?", 1).select('id, nome, cidade as cidade_nome, direcao, bairro, telefone, tabela_preco_id')
    usuarios = Usuario.where("forca_venda = ?", true).select('id, usuario_nome, usuario_senha')
    produtos = Produto.find_by_sql('select produtos.id, produtos.nome, clases.descricao as marca, produtos.fabricante_cod
                                    from produtos
                                    left outer join clases on clases.id = produtos.clase_id
                                    where produtos.status = true')
    tabela_precos_produtos = ProdutosTabelaPreco.find_by_sql('select ptp.id, produto_id, tabela_preco_id, preco_1_gs
                                                              from produtos_tabela_precos ptp
                                                              inner join produtos p on p.id = ptp.produto_id
                                                              where p.status = true')
    stocks = Stock.find_by_sql('select p.id as produto_id,
                                       (select sum(entrada - saida)
                                        from stocks s
                                        where (s.produto_id = p.id and s.deposito_id = 1) ) as stocks
                                from produtos p
                                where p.status = true')
    forma_pagos = Plano.select('id, condicao')

    return render :json => { :clientes => clientes,
                             :produtos => produtos,
                             :usuarios => usuarios,
                             :tabela_precos_produtos => tabela_precos_produtos,
                             :stocks => stocks,
                             :forma_pagos => forma_pagos
                           }

  end

  # GET /config_printers
  # GET /config_printers.json
  def index
    @config_printers = ConfigPrinter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @config_printers }
    end
  end

  # GET /config_printers/1
  # GET /config_printers/1.json
  def show
    @config_printer = ConfigPrinter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @config_printer }
    end
  end

  # GET /config_printers/new
  # GET /config_printers/new.json
  def new
    @config_printer = ConfigPrinter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @config_printer }
    end
  end

  # GET /config_printers/1/edit
  def edit
    @config_printer = ConfigPrinter.find(params[:id])
  end

  # POST /config_printers
  # POST /config_printers.json
  def create
    @config_printer = ConfigPrinter.new(params[:config_printer])

    respond_to do |format|
      if @config_printer.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to config_printers_url }
      else
        format.html { render action: "new" }
        format.json { render json: @config_printer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /config_printers/1
  # PUT /config_printers/1.json
  def update
    @config_printer = ConfigPrinter.find(params[:id])

    respond_to do |format|
      if @config_printer.update_attributes(params[:config_printer])
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to config_printers_url }
      else
        format.html { render action: "edit" }
        format.json { render json: @config_printer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /config_printers/1
  # DELETE /config_printers/1.json
  def destroy
    @config_printer = ConfigPrinter.find(params[:id])
    @config_printer.destroy

    respond_to do |format|
      format.html { redirect_to config_printers_url }
      format.json { head :no_content }
    end
  end
end

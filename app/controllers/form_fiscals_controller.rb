class FormFiscalsController < ApplicationController

  def reenviar
    @form_fiscal = FormFiscal.find(params[:id])
    @venda = Venda.find(@form_fiscal.cod_proc)
  end

  def cancelacion

    lanz = FormFiscal.find_by_id(params[:inu_id])

      data = {
        cdc: lanz.cdc,
        motivo: params[:inu_motivo]
      }

        url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/evento/cancelacion")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
        request["content-type"] = 'application/json'
        # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
        puts data.to_json
        request.body = data.to_json
        puts '----------------------------------------------------------------------'
        response = http.request(request)
        puts get_resp = JSON.parse(response.body)

        puts get_resp['success']

        if get_resp['success'] == true
          lanz.update_attributes(status: 2, motivo: params[:motivo])

          return render :json => { :fe => get_resp }
        end
  end


  def inutilizacion

    lanz = FormFiscal.find_by_id(params[:inu_id])

      data = {
        tipoDocumento: lanz.tipo_doc,
        establecimiento: lanz.doc_01,
        punto: lanz.doc_02,
        desde: lanz.doc,
        hasta: lanz.doc,
        motivo: params[:inu_motivo]
      }

        url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/evento/inutilizacion")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
        request["content-type"] = 'application/json'
        # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
        puts data.to_json
        request.body = data.to_json
        puts '----------------------------------------------------------------------'
        response = http.request(request)
        puts get_resp = JSON.parse(response.body)

        puts get_resp['success']

        if get_resp['success'] == true
          lanz.update_attributes(status: 3, motivo: params[:motivo])

          return render :json => { :fe => get_resp }
        end
  end

  def compra_update_af
    lanz = FormFiscal.find_by_id(params[:busca]['doc'])

    if lanz.tipo_emissao.to_i == 0

    else #fatura eletronica

      pers = Persona.find_by_id(params[:persona_id])
      ctz = Moeda.last
      contrato_servicos = ComprasProduto.select('produto_id,produto_nome,quantidade,total_guarani,total_dolar,unitario_guarani, unitario_dolar').where(compra_id: params[:cod_proc]).order(:id)
      vendas_financas = VendasFinanca.select('id,venda_id,desc_gs').where(venda_id: params[:cod_proc])
      venda = Compra.find_by_id(params[:cod_proc])

      if params[:moeda].to_i == 1
        md = 'PYG'
        condicionTipoCambio = "null"
        cambio = "null"
        monto = contrato_servicos.sum('total_guarani').to_i
        monedaDescripcion = 'Guarani'
        desconto_global = 0
      else
        md = 'USD'
        condicionTipoCambio = 1
        cambio = venda.cotacao.to_i
        monto = contrato_servicos.sum('total_dolar').to_f
        monedaDescripcion = 'Dolar'
        desconto_global = 0
      end

        list_prods = []

        contrato_servicos.each do |cs|
          iva_tipo = 1
          iva_base = 100

          if cs.produto.taxa.to_i == 0
            iva_tipo = 3
            iva_base = 0
          elsif cs.produto.taxa.to_i == 5
            iva_tipo = 1
            iva_base = 100
          elsif cs.produto.taxa.to_i == 10
            iva_tipo = 1
            iva_base = 100
          end

          if cs.produto.embalagem == 'LT'
            unidade_medido = 89
          else
            unidade_medido = 77
          end


          if params[:moeda].to_i == 1
            precioUnitario = cs.unitario_guarani.to_i
          else
            precioUnitario = cs.unitario_dolar.to_f
          end



          list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
            descripcion: cs.produto.nome,
            unidadMedida: cs.produto.unidade_medida_id,
            cantidad: cs.quantidade.to_f,
            precioUnitario: precioUnitario,
            ivaTipo: iva_tipo,
            ivaBase: iva_base,
            iva: cs.produto.taxa.to_i}]
        end


      #condição
        cd_detalhe =  {tipo: 1, entregas: [{
            tipo: 1,
            monto: monto,
            moneda: md,
            monedaDescripcion: monedaDescripcion,
            cambio: cambio
        }]}


      #tipo cliente

        cliente = {
                      contribuyente: true,
                      ruc: current_unidade.ruc,
                      razonSocial: 'Mairon Daniel Centurion Brasil',
                      nombreFantasia: 'Mairon Daniel Centurion Brasil',
                      tipoOperacion: 2,
                      tipoContribuyente: 1,
                      documentoTipo: 1,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id
                  }


      data = {ch:  [{
                  tipoDocumento: 4,
                  establecimiento: lanz.doc_01,
                  serie: lanz.serie,
                  punto: lanz.doc_02.to_s.gsub(' ', ''),
                  numero: lanz.doc,
                  fecha: "#{params[:data].to_date.strftime("%Y-%m-%d")}T#{Time.now.strftime('%H:%M:%S')}",
                  tipoEmision: 1,
                  tipoTransaccion: 1,
                  tipoImpuesto: 1,
                  moneda: md,
                  condicionTipoCambio: condicionTipoCambio,
                  descuentoGlobal: desconto_global,
                  cambio: cambio,
                  cliente: cliente,
                  observacion: "Chronos Software",
                  usuario: {
                      documentoTipo: 1,
                      documentoNumero: '157264',
                      nombre: 'Marcos Jara',
                      cargo: 'Vendedor'
                  },

                  autoFactura: {
                          tipoVendedor: 1,
                          documentoTipo: 1,
                          documentoNumero: pers.ruc,
                          nombre: pers.nome,
                          direccion: pers.direcao,
                          pais: 'PRY',
                          paisDescripcion: 'Paraguay',
                          numeroCasa: "0",
                          departamento: pers.cidade.distrito.estado.api_id,
                          distrito: pers.cidade.distrito.api_id,
                          ciudad: pers.cidade.api_id,
                          ubicacion: {
                                lugar: "CIDADAD DEL ESTE",
                                departamento: pers.cidade.distrito.estado.api_id,
                                distrito: pers.cidade.distrito.api_id,
                                ciudad: pers.cidade.api_id

                            }
                          },


                  factura: {
                      presencia: 1
                  },
                  condicion: cd_detalhe,
                  items: list_prods,
                  documentoAsociado: {
                        formato: 3,
                        constanciaTipo: 1,
                        constanciaNumero: pers.constancia_numero,
                        constanciaControl: pers.constancia_control

                    }
              }]}


          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data[:ch].to_json
          request.body = data[:ch].to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          puts get_resp = JSON.parse(response.body)

          puts '-----------------======-----------------------------------------------------'
          puts get_resp['success']

          if get_resp['success'] == true

            lanz.update_attributes(cod_proc: params[:cod_proc],
                         sigla_proc: params[:sigla_proc],
                         data: params[:data],
                         status: params[:status],
                         tipo: params[:tipo],
                         ruc: params[:ruc],
                         persona_nome: params[:persona_nome],
                         persona_id: params[:persona_id],
                         cota: params[:cota],
                         tipo_op: params[:tipo_op],
                         moeda: params[:moeda],
                         cdc: get_resp["result"]["deList"].last["cdc"],
                         tot_gs: params[:tot_gs] )

          end

          return render :json => { :fe => get_resp }
    end


  end


  def fatura_matricial

    @ft = FormFiscal.find_by_id(params[:id])

    if @ft.sigla_proc == 'FI'
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)
      @fact_indep_produtos = FactIndepProduto.where("fact_indep_id = #{@ft.cod_proc}")
    elsif @ft.sigla_proc == 'CB'
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)
      @venda = Cobro.find_by_id(@ft.cod_proc)
    else
      @venda = Venda.find_by_id(@ft.cod_proc)
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)

      sql = "SELECT P.PRODUTO_ID AS PRODUTO_ID,
                    P.UNITARIO_DOLAR AS UNITARIO_DOLAR,
                    MAX(P.PRODUTO_NOME) AS PRODUTO_NOME,
                    MAX(P.TAXA) AS TAXA,
                    MAX(P.UNITARIO_GUARANI) AS UNITARIO_GUARANI,

                    SUM(P.QUANTIDADE) AS QUANTIDADE,
                    SUM(P.QUANTIDADE * P.UNITARIO_GUARANI) AS TOTAL_GUARANI,
                    SUM(P.QUANTIDADE * P.UNITARIO_DOLAR) AS TOTAL_DOLAR
                    FROM VENDAS_PRODUTOS P
                    WHERE P.VENDA_ID = #{@ft.cod_proc}
                    GROUP BY 1,2"

      @venda_produto = VendasProduto.find_by_sql(sql)

      @produto_sum_dolar    = VendasProduto.sum(:total_dolar,:conditions => ["venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_guarani  = VendasProduto.sum(:total_guarani,:conditions => ["venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva10_us = VendasProduto.sum('total_dolar / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva10_gs = VendasProduto.sum('total_guarani / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva05_us = VendasProduto.sum('total_dolar / 21',:conditions => ["taxa = 5 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva05_gs = VendasProduto.sum('total_guarani / 21',:conditions => ["taxa = 5 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva80_us = VendasProduto.sum('iva_dolar * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva80_gs = VendasProduto.sum('iva_guarani * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",@ft.cod_proc.to_i] )
    end
    render layout: false

  end


  def gera_pdf_cdc

      data = { cdcList: [
          {
          cdc: params[:cdc]
            }
          ]}

          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/de/pdf")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data.to_json
          request.body = data.to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          #send_data(xls,:filename => "resultado_ponto_funciario-#{params[:mes]}-#{params[:ano]}.xls")

          #send_data File.open(Base64.encode64(response.body), 'rb').read, type: 'application/pdf', filename: 'abc.pdf'

          lanz = FormFiscal.find_by_id(params[:id])

          lanz.update_attributes(arquivo_pdf: Base64.encode64(response.body))

          send_data( Base64.decode64(lanz.arquivo_pdf),:filename => "#{lanz.doc_01}-#{lanz.doc_02}-#{lanz.doc.to_s.rjust(7,'0')}.pdf")
  end


  def transmite_de
          data =  [{
            tipoDocumento: 5,
            establecimiento: 1,
            punto: "001",
            numero: 1,
            descripcion: "monto equivocado",
            observacion: "monto equivocado",
            tipoContribuyente: 1,
            fecha: "2023-02-27T23:00:00",
            tipoEmision: 1,
            tipoTransaccion: 2,
            tipoImpuesto: 1,
            moneda: "USD",
            condicionTipoCambio: 1,
            cambio: 7340,
            cliente: {
                contribuyente: true,
                ruc: "80058558-5",
                codigo: "000031",
                razonSocial: "DIST. 3 FRONTERAS S.A",
                nombreFantasia: "DIST. 3 FRONTERAS S.A",
                tipoOperacion: 1,
                direccion: "",
                numeroCasa: "",
                departamento: 11,
                distrito: 209,
                ciudad: 3556,
                pais: "PRY",
                tipoContribuyente: 1,
                documentoTipo: 1,
                email: ""
            },
            usuario: {
                documentoTipo: 1,
                documentoNumero: "7723670",
                nombre: "Mairon",
                cargo: "Vendedor"
            },
            notaCreditoDebito: {
                motivo: 1
            },
            items: [{
                codigo: "000020",
                descripcion: "INSTALACION DE ANTIVIRUS",
                cantidad: 20,
                precioUnitario: 480.00,
                pais: "PRY",
                ivaTipo: 1,
                ivaBase: 100,
                iva: 10
            }],
            documentoAsociado: {
                formato: 1,
                cdc: "01077236700001001000010222023012314489387157"
            }
        }]
          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data.to_json
          request.body = data.to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          puts get_resp = JSON.parse(response.body)


          respond_to do |format|
            format.html { redirect_to form_fiscals_path}
          end
  end

  def fact_indep_update_ft

    lanz = FormFiscal.find_by_id(params[:busca]['doc'])
    lanz.update_attributes(cod_proc: params[:cod_proc],
                           sigla_proc: params[:sigla_proc],
                           data: params[:data],
                           status: params[:status],
                           tipo: params[:tipo],
                           ruc: params[:ruc],
                           persona_nome: params[:persona_nome],
                           persona_id: params[:persona_id],
                           cota: params[:cota],
                           tipo_op: params[:tipo_op],
                           moeda: params[:moeda],
                           tot_gs: params[:tot_gs] )
    venda = VendasFinanca.find_by_venda_id(params[:cod_proc])

    redirect_to fact_indep_path(lanz.cod_proc)
  end


  def nc
    @nc = FormFiscal.find_by_id(params[:id])
    render layout: false
  end


  def impressao_rc
    @ft = FormFiscal.find_by_id(params[:id])
    if @ft.sigla_proc == 'CB'
      @cobro = Cobro.find_by_id(@ft.cod_proc)

      @cd           = CobrosDetalhe.all(:conditions => ['cobro_id = ?',@cobro.id])
      @cf           = CobrosFinanca.all(:conditions => ['cobro_id = ?',@cobro.id])
      @total_gs     = CobrosDetalhe.sum( :cobro_guarani,   :conditions => ['cobro_id = ?',@cobro.id])
      @total_us     = CobrosFinanca.sum('valor_dolar',:conditions => ['cobro_id = ?',@cobro.id])
      @cf_last      = CobrosFinanca.last(:conditions => ['cobro_id = ?',@cobro.id])
      @cheque_true  = CobrosFinanca.all(:conditions => ['cheque_status = 1 and cobro_id = ?',@cobro.id])
      @cheque_false = CobrosFinanca.all(:conditions => ['cheque_status = 0 and cobro_id = ?',@cobro.id])
      @cd          = CobrosDetalhe.all(:conditions => ['cobro_id = ?',@cobro.id])
      @tot_cobro_us = CobrosDetalhe.sum( :cobro_dolar,     :conditions => ['cobro_id = ?',@cobro.id])
      @tot_cobro_gs = CobrosDetalhe.sum( :cobro_guarani,   :conditions => ['cobro_id = ?',@cobro.id])
      @tot_cobro_rs = CobrosDetalhe.sum( :cobro_real,      :conditions => ['cobro_id = ?',@cobro.id])
      @tot_des_us   = CobrosDetalhe.sum( :desconto_dolar,  :conditions => ['cobro_id = ?',@cobro.id])
      @tot_des_gs   = CobrosDetalhe.sum( :desconto_guarani,:conditions => ['cobro_id = ?',@cobro.id])
      @tot_des_rs   = CobrosDetalhe.sum( :desconto_real,   :conditions => ['cobro_id = ?',@cobro.id])
      @tot_int_us   = CobrosDetalhe.sum( :interes_dolar,   :conditions => ['cobro_id = ?',@cobro.id])
      @tot_int_gs   = CobrosDetalhe.sum( :interes_guarani, :conditions => ['cobro_id = ?',@cobro.id])
      @tot_int_rs   = CobrosDetalhe.sum( :interes_real, :conditions => ['cobro_id = ?',@cobro.id])
      @tot_ade_us   = CobrosAdelanto.sum( :valor_us,   :conditions => ['cobro_id = ?',@cobro.id])
      @tot_ade_gs   = CobrosAdelanto.sum( :valor_gs, :conditions => ['cobro_id = ?',@cobro.id])
      @tot_ade_rs   = CobrosAdelanto.sum( :valor_rs, :conditions => ['cobro_id = ?',@cobro.id])

      @fecha_result_us = ( ( @tot_cobro_us.to_f + @tot_int_us.to_f ) - ( @tot_des_us.to_f + @tot_ade_us.to_f ) )
      @fecha_result_gs = ( ( @tot_cobro_gs.to_f + @tot_int_gs.to_f ) - ( @tot_des_gs.to_f + @tot_ade_gs.to_f ) )
      @fecha_result_rs = ( ( @tot_cobro_rs.to_f + @tot_int_rs.to_f ) - ( @tot_des_rs.to_f + @tot_ade_rs.to_f ) )

      @financ_cred_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
      @financ_cred_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
      @financ_cred_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])

      @financ_deb_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
      @financ_deb_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
      @financ_deb_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])

      @saldo_fina_us = ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us )
      @saldo_fina_gs = ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs )
      @saldo_fina_rs = ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs )


    elsif @ft.sigla_proc == 'CT'
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)
      @venda = Contrato.find_by_id(@ft.cod_proc)
    end

    render layout: false
  end

  def impressao_rc_adelanto
    @ft = FormFiscal.find_by_id(params[:id])
    @adelanto    = Adelanto.find(@ft.cod_proc)
    render layout: false
  end


  def impressao_ft
    @ft = FormFiscal.find_by_id(params[:id])
    if @ft.sigla_proc == 'FI'
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)
      @fact_indep_produtos = FactIndepProduto.where("fact_indep_id = #{@ft.cod_proc}")
    elsif @ft.sigla_proc == 'CB'
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)
      @venda = Cobro.find_by_id(@ft.cod_proc)
      cobros_vendas = CobrosDetalhe.where("estado = 1 and venda_id > 0 and cobro_id = #{@ft.cod_proc}")

      if cobros_vendas.count(:id) > 0
        ids = cobros_vendas.map  { |t| t.venda_id }.join(', ')
      else
        ids = 0
      end
      sql =  "SELECT
                     PRODUTO_ID,
                     SUM(VP.QUANTIDADE) AS QUANTIDADE,
                     SUM(VP.TOTAL_GUARANI) AS TOTAL_GUARANI,
                     SUM(VP.TOTAL_DOLAR) AS TOTAL_DOLAR,
                     MAX(VP.UNITARIO_GUARANI) AS UNITARIO_GUARANI,
                     MAX(VP.UNITARIO_DOLAR) AS UNITARIO_DOLAR,
                     MAX(VP.PRODUTO_NOME) AS PRODUTO_NOME,
                     MAX(VP.ABASTECIDA_ID) AS ABASTECIDA_ID,
                     MAX(VP.BICO_ID) AS BICO_ID,
                     MAX(VP.TAXA) AS TAXA
              FROM VENDAS_PRODUTOS VP
              INNER JOIN VENDAS V
              ON V.ID = VP.VENDA_ID

              WHERE VENDA_ID IN ( #{ids} )
              AND V.DOCUMENTO_NUMERO_01 = '000'
              GROUP BY 1
              "
      @cobros_vendas_produtos = VendasProduto.find_by_sql(sql)
    elsif @ft.sigla_proc == 'CT'
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)
      @venda = Contrato.find_by_id(@ft.cod_proc)

    else
      @venda = Venda.find_by_id(@ft.cod_proc)
      @config_impr = ConfigForm.find_by_unidade_id(current_unidade.id)

      sql = "SELECT P.PRODUTO_ID AS PRODUTO_ID,
                    P.UNITARIO_DOLAR AS UNITARIO_DOLAR,
                    MAX(P.PRODUTO_NOME) AS PRODUTO_NOME,
                    MAX(P.TAXA) AS TAXA,
                    MAX(P.UNITARIO_GUARANI) AS UNITARIO_GUARANI,

                    SUM(P.QUANTIDADE) AS QUANTIDADE,
                    SUM(P.QUANTIDADE * P.UNITARIO_GUARANI) AS TOTAL_GUARANI,
                    SUM(P.QUANTIDADE * P.UNITARIO_DOLAR) AS TOTAL_DOLAR
                    FROM VENDAS_PRODUTOS P
                    WHERE P.VENDA_ID = #{@ft.cod_proc}
                    GROUP BY 1,2"

      @venda_produto = VendasProduto.find_by_sql(sql)

      @produto_sum_dolar    = VendasProduto.sum(:total_dolar,:conditions => ["venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_guarani  = VendasProduto.sum(:total_guarani,:conditions => ["venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva10_us = VendasProduto.sum('total_dolar / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva10_gs = VendasProduto.sum('total_guarani / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva05_us = VendasProduto.sum('total_dolar / 21',:conditions => ["taxa = 5 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva05_gs = VendasProduto.sum('total_guarani / 21',:conditions => ["taxa = 5 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva80_us = VendasProduto.sum('iva_dolar * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",@ft.cod_proc.to_i] )
      @produto_sum_iva80_gs = VendasProduto.sum('iva_guarani * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",@ft.cod_proc.to_i] )
    end
    render layout: false

  end

  def atualiza_fatura_independente

    lanz = FormFiscal.find_by_id(params[:busca]['doc'])
    lanz.update_attributes(cod_proc: params[:busca]['doc'],
                           sigla_proc: params[:sigla_proc],
                           data: params[:data],
                           status: params[:status],
                           tipo: params[:fatura]["tipo"],
                           persona_id: params[:busca]["persona"],
                           cota: params[:cota],
                           tipo_op: params[:tipo_op],
                           moeda: params[:fatura]["moeda"],
                           tot_gs: params[:tot_gs],
                           tot_us: params[:tot_us],
                           qtd: params[:qtd],
                           unit_gs: params[:unit_gs],
                           unit_us: params[:unit_us],
                           produto_id: params[:busca]["produto"])

    redirect_to form_fiscal_path(lanz.cod_proc)


  end

  def update_impressao
    @ft = FormFiscal.find_by_id(params[:id])
    @ft.update_attribute :impressao, @ft.impressao.to_i + 1
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def anula_nc
    lanz = FormFiscal.find_by_id(params[:id])
    if params[:status] == '0'
    	lanz.update_attributes(persona_nome: '')
    	lanz.update_attributes(ruc: '')
    end

    if lanz.tipo_emissao.to_i == 1
      if params[:status] == '2'
      data = {
        cdc: lanz.cdc,
        motivo: params[:motivo]
      }

        url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/evento/cancelacion")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
        request["content-type"] = 'application/json'
        # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
        puts data.to_json
        request.body = data.to_json
        puts '----------------------------------------------------------------------'
        response = http.request(request)
        puts get_resp = JSON.parse(response.body)
      end
    end



    	lanz.update_attributes(status: params[:status], motivo: params[:motivo])
    if lanz.sigla_proc == 'VT'
    	VendasFinanca.destroy_all("venda_id = #{lanz.cod_proc}" )
      if lanz.tipo_emissao.to_i == 1
              data = {
                cdc: lanz.cdc,
                motivo: params[:motivo]
              }

                url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/evento/cancelacion")

                http = Net::HTTP.new(url.host, url.port)
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                request = Net::HTTP::Post.new(url)
                request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
                request["content-type"] = 'application/json'
                # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
                puts data.to_json
                request.body = data.to_json
                puts '----------------------------------------------------------------------'
                response = http.request(request)
                puts get_resp = JSON.parse(response.body)
            end

      redirect_to financas_venda_path(lanz.cod_proc)

    elsif lanz.sigla_proc == 'CB'
      if lanz.tipo_emissao.to_i == 1
              data = {
                cdc: lanz.cdc,
                motivo: params[:motivo]
              }

                url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/evento/cancelacion")

                http = Net::HTTP.new(url.host, url.port)
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                request = Net::HTTP::Post.new(url)
                request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
                request["content-type"] = 'application/json'
                # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
                puts data.to_json
                request.body = data.to_json
                puts '----------------------------------------------------------------------'
                response = http.request(request)
                puts get_resp = JSON.parse(response.body)
            end

      redirect_to cobro_final_cobro_path(lanz.cod_proc)

    elsif lanz.sigla_proc == 'CBP'
      if lanz.tipo_emissao.to_i == 1
              data = {
                cdc: lanz.cdc,
                motivo: params[:motivo]
              }

                url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/evento/cancelacion")

                http = Net::HTTP.new(url.host, url.port)
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                request = Net::HTTP::Post.new(url)
                request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
                request["content-type"] = 'application/json'
                # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
                puts data.to_json
                request.body = data.to_json
                puts '----------------------------------------------------------------------'
                response = http.request(request)
                puts get_resp = JSON.parse(response.body)
            end
      redirect_to documentos_nota_credito_path(lanz.cod_proc)
    elsif lanz.sigla_proc == 'CP'
      redirect_to compras_financa_compra_path(lanz.cod_proc)
    elsif lanz.sigla_proc == 'PG'
      redirect_to pago_final_pago_path(lanz.cod_proc)
    elsif lanz.sigla_proc == 'FI'
      redirect_to fact_indep_path(lanz.cod_proc)
    elsif lanz.sigla_proc == 'AD'
      redirect_to adelanto_path(lanz.cod_proc)
    elsif lanz.sigla_proc == 'CT' #contrato

      clientes = Cliente.where(tabela_id: lanz.cod_proc, tabela: 'CONTRATOS')

      ct = Contrato.find_by_id(lanz.cod_proc)
      #atulizar numero do documento
      ct.update_attributes(documento_numero: lanz.cod_proc)

      seq = 0
      clientes.each do |vf|
        seq += 1
        vf.update_attributes(documento_numero: "#{lanz.cod_proc}-#{seq}",
                                documento_numero_01: '000',
                                documento_numero_02: '000')
      end


      redirect_to contrato_path(lanz.cod_proc)

    elsif lanz.sigla_proc == 'CL'
      venda = Cliente.find_by_id(lanz.cod_proc)

        if lanz.tipo_emissao.to_i == 1
          data = {
            cdc: lanz.cdc,
            motivo: params[:motivo]
          }

            url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/evento/cancelacion")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(url)
            request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
            request["content-type"] = 'application/json'
            # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
            puts data.to_json
            request.body = data.to_json
            puts '----------------------------------------------------------------------'
            response = http.request(request)
            puts get_resp = JSON.parse(response.body)
        end

      #atulizar numero do documento
      venda.update_attributes(documento_numero: ('CONTR' + venda.cod_proc.to_s),
                              documento_numero_01: '000',
                              documento_numero_02: '000')

      redirect_to faturamento_cliente_path(lanz.cod_proc, terminal_id: lanz.terminal_id )
    else

      #Cobro
      cobro_fin = CobrosFinanca.where(cobro_id: lanz.cod_proc)

      cobro_fin.each do |cf|
        cf.update_attributes(documento_numero_01: '000',
          documento_numero_02: '000',
          numero_recibo: 'CP' + lanz.cod_proc.to_s)
      end

      redirect_to cobro_final_cobro_path(lanz.cod_proc)
    end
  end

  def retencao_update_cp

    lanz = FormFiscal.find_by_id(params[:busca]['doc'])
    lanz.update_attributes(cod_proc: params[:cod_proc],
                           sigla_proc: params[:sigla_proc],
                           data: params[:data],
                           status: params[:status],
                           tipo: params[:tipo],
                           ruc: params[:ruc],
                           persona_nome: params[:persona_nome],
                           persona_id: params[:persona_id],
                           cota: params[:cota],
                           tipo_op: params[:tipo_op],
                           moeda: params[:moeda],
                           tot_gs: params[:tot_gs],
                           tot_us: params[:tot_us])
    if lanz.sigla_proc == 'PG'
      redirect_to pago_final_pago_path(lanz.cod_proc)
    else
      redirect_to compras_financa_compra_path(lanz.cod_proc)
    end
  end

  def venda_update_ft

    lanz = FormFiscal.find_by_id(params[:busca]['doc'])

    if lanz.tipo_emissao.to_i == 0
      lanz.update_attributes(cod_proc: params[:cod_proc],
                             sigla_proc: params[:sigla_proc],
                             data: params[:data],
                             status: params[:status],
                             tipo: params[:tipo],
                             ruc: params[:ruc],
                             persona_nome: params[:persona_nome],
                             persona_id: params[:persona_id],
                             cota: params[:cota],
                             tipo_op: params[:tipo_op],
                             moeda: params[:moeda],
                             tot_gs: params[:tot_gs] )
      vendaf = VendasFinanca.where(venda_id: params[:cod_proc])
      venda = Venda.find_by_id(params[:cod_proc])
      #atulizar numero do documento
      venda.update_attributes(documento_numero: lanz.doc,
                              documento_numero_01: lanz.doc_01,
                              documento_numero_02: lanz.doc_02)
      vendaf.each do |vf|
        vf.update_attributes(documento_numero: lanz.doc,
                                documento_numero_01: lanz.doc_01,
                                documento_numero_02: lanz.doc_02)
      end
      redirect_to financas_venda_path(lanz.cod_proc)

    else #fatura eletronica

      pers = Persona.find_by_id(params[:persona_id])
      ctz = Moeda.last
      contrato_servicos = VendasProduto.select('obs,produto_id,produto_nome,quantidade,total_guarani,total_dolar,unitario_guarani, unitario_dolar').where(venda_id: params[:cod_proc]).order(:id)
      vendas_financas = VendasFinanca.select('id,venda_id,desc_gs').where(venda_id: params[:cod_proc])
      venda = Venda.find_by_id(params[:cod_proc])
      if params[:moeda].to_i == 1
        md = 'PYG'
        condicionTipoCambio = "null"
        cambio = "null"
        monto = contrato_servicos.sum('total_guarani').to_i
        monedaDescripcion = 'Guarani'
        desconto_global = venda.desconto_gs.to_i
      else
        md = 'USD'
        condicionTipoCambio = 1
        cambio = venda.cotacao.to_i
        monto = contrato_servicos.sum('total_dolar').to_f
        monedaDescripcion = 'Dolar'
        desconto_global = venda.desconto_us.to_f
      end

        list_prods = []

        contrato_servicos.each do |cs|
          iva_tipo = 1
          iva_base = 100

          if cs.produto.taxa.to_i == 0
            iva_tipo = 3
            iva_base = 0
            iva = 0
          elsif cs.produto.taxa.to_i == 5
            iva_tipo = 1
            iva_base = 100
            iva = 5
          elsif cs.produto.taxa.to_i == 10
            iva_tipo = 1
            iva_base = 100
            iva = 10
          elsif cs.produto.taxa.to_i == 70
            iva_tipo = 4
            iva_base = 30
            iva = 10
          end

          if cs.produto.embalagem == 'LT'
            unidade_medido = 89
          else
            unidade_medido = 77
          end


          if params[:moeda].to_i == 1
            precioUnitario = cs.unitario_guarani.to_i
          else
            precioUnitario = cs.unitario_dolar.to_f
          end


          unless cs.obs.blank?
            prod_nome = cs.obs
          else
            prod_nome =  cs.produto_nome
          end

          list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
            descripcion: prod_nome,
            unidadMedida: cs.produto.unidade_medida_id,
            cantidad: cs.quantidade.to_f,
            precioUnitario: precioUnitario,
            ivaTipo: iva_tipo,
            ivaBase: iva_base,
            iva: iva}]
        end


      #condição
      if venda.tipo.to_i == 0
        cd_detalhe =  {tipo: 1, entregas: [{
            tipo: 1,
            monto: monto,
            moneda: md,
            monedaDescripcion: monedaDescripcion,
            cambio: cambio
        }]}

      elsif venda.tipo.to_i == 1

        praz = ''
        unless venda.tabela_preco.obs.blank?
          praz = venda.tabela_preco.obs
        else
          praz = '30 Dias'
        end

        cd_detalhe = { tipo: 2, credito: {
          tipo: 1,
          plazo: praz,
          cuotas: 1,
          infoCuotas: [{
              moneda: "PYG",
              monto: monto,
              vencimiento: params[:vencimento]
          }]
      }}
      end


      #tipo cliente
      if params[:ruc].to_s.gsub('.', '').count('-').to_i == 0
        cliente = {
                      contribuyente: false,
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 2,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      documentoTipo: 1,
                      documentoNumero: params[:ruc],
                      email: pers.email
                  }
      else
        cliente = {
                      contribuyente: true,
                      ruc: params[:ruc],
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 1,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      tipoContribuyente: 2,
                      email: pers.email
                  }
      end


      data = {ch:  [{
                  tipoDocumento: 1,
                  establecimiento: lanz.doc_01,
                  serie: lanz.serie,
                  punto: lanz.doc_02.to_s.gsub(' ', ''),
                  numero: lanz.doc,
                  fecha: "#{params[:data].to_date.strftime("%Y-%m-%d")}T#{Time.now.strftime('%H:%M:%S')}",
                  tipoEmision: 1,
                  tipoImpuesto: 1,
                  moneda: md,
                  condicionTipoCambio: condicionTipoCambio,
                  descuentoGlobal: desconto_global,
                  cambio: cambio,
                  cliente: cliente,
                  observacion: "Chronos Software | #{venda.obs}",
                  usuario: {
                      documentoTipo: 1,
                      documentoNumero: '157264',
                      nombre: 'Marcos Jara',
                      cargo: 'Vendedor'
                  },
                  factura: {
                      presencia: 1
                  },
                  condicion: cd_detalhe,
                  items: list_prods
              }]}


          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data[:ch].to_json
          request.body = data[:ch].to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          puts get_resp = JSON.parse(response.body)

          puts '-----------------======-----------------------------------------------------'
          puts get_resp['success']

          if get_resp['success'] == true

            lanz.update_attributes(cod_proc: params[:cod_proc],
                         sigla_proc: params[:sigla_proc],
                         data: params[:data],
                         status: params[:status],
                         tipo: params[:tipo],
                         ruc: params[:ruc],
                         persona_nome: params[:persona_nome],
                         persona_id: params[:persona_id],
                         cota: params[:cota],
                         tipo_op: params[:tipo_op],
                         moeda: params[:moeda],
                         cdc: get_resp["result"]["deList"].last["cdc"],
                         tot_gs: params[:tot_gs] )

            vendaf = VendasFinanca.where(venda_id: params[:cod_proc])
            venda = Venda.find_by_id(params[:cod_proc])
            #atulizar numero do documento
            venda.update_attributes(documento_numero: lanz.doc,
                                    documento_numero_01: lanz.doc_01,
                                    documento_numero_02: lanz.doc_02)
            vendaf.each do |vf|
              if vf.forma_pago_id != 23
                vf.update_attributes(documento_numero: lanz.doc,
                                      documento_numero_01: lanz.doc_01,
                                      documento_numero_02: lanz.doc_02)
              end
            end
          end

          return render :json => { :fe => get_resp }
    end
  end


  def contrato_update_ft

    lanz = FormFiscal.find_by_id(params[:busca]['doc'])

    if lanz.tipo_emissao.to_i == 0
      lanz.update_attributes(cod_proc: params[:cod_proc],
                             sigla_proc: params[:sigla_proc],
                             data: params[:data],
                             status: params[:status],
                             tipo: params[:tipo],
                             ruc: params[:ruc],
                             persona_nome: params[:persona_nome],
                             persona_id: params[:persona_id],
                             cota: params[:cota],
                             tipo_op: params[:tipo_op],
                             moeda: params[:moeda],
                             tot_gs: params[:tot_gs] )

      clientes = Cliente.where(tabela_id: params[:cod_proc], tabela: 'CONTRATOS')

      ct = Contrato.find_by_id(params[:cod_proc])
      #atulizar numero do documento
      ct.update_attributes(documento_numero: lanz.doc)

      seq = 0
      clientes.each do |vf|
        seq += 1
        vf.update_attributes(documento_numero: "#{lanz.doc}-#{seq}",
                                documento_numero_01: lanz.doc_01,
                                documento_numero_02: lanz.doc_02)
      end

      redirect_to contrato_path(lanz.cod_proc)

    else #fatura eletronica
      pers = Persona.find_by_id(params[:persona_id])
      ctz = Moeda.last
      contrato_servicos = ContratoServico.select('produto_id,quantidade,total_gs,total_us,unitario_gs, unitario_us,obs').where(contrato_id: params[:cod_proc])

      if params[:moeda].to_i == 1
        md = 'PYG'
        condicionTipoCambio = "null"
        cambio = "null"
        monto = contrato_servicos.sum('total_gs').to_i
        monedaDescripcion = 'Guarani'
      else
        md = 'USD'
        condicionTipoCambio = 1
        cambio = ctz.dolar_venda
        monto = contrato_servicos.sum('total_us').to_f
        monedaDescripcion = 'Dolar'
      end

        list_prods = []

        contrato_servicos.each do |cs|

          iva_tipo = 1
          iva_base = 100

          if cs.produto.taxa.to_i == 0
            iva_tipo = 3
            iva_base = 0
            iva = 0
          elsif cs.produto.taxa.to_i == 5
            iva_tipo = 1
            iva_base = 100
            iva = 5
          elsif cs.produto.taxa.to_i == 10
            iva_tipo = 1
            iva_base = 100
            iva = 10
          elsif cs.produto.taxa.to_i == 70
            iva_tipo = 4
            iva_base = 30
            iva = 10
          end

          if cs.produto.embalagem == 'LT'
            unidade_medido = 89
          else
            unidade_medido = 77
          end


          if params[:moeda].to_i == 1
            precioUnitario = cs.unitario_gs.to_i
          else
            precioUnitario = cs.unitario_us.to_f
          end
          list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
            descripcion: cs.produto.nome,
            observacion: cs.obs,
            unidadMedida: unidade_medido,
            cantidad: cs.quantidade,
            precioUnitario: precioUnitario,
            ivaTipo: iva_tipo,
            ivaBase: iva_base,
            iva: iva}]
        end


      #condição
      if params[:tipo].to_i == 0
        cd_detalhe =  {tipo: 1, entregas: [{
            tipo: 1,
            monto: monto,
            moneda: md,
            monedaDescripcion: monedaDescripcion,
            cambio: cambio
        }]}

      elsif params[:tipo].to_i == 1
        cd_detalhe = { tipo: 2, credito: {
          tipo: 1,
          plazo: "30 días",
          cuotas: 1,
          infoCuotas: [{
              moneda: "PYG",
              monto: monto,
              vencimiento: params[:data].to_date + 30
          }]
      }}
      end


      #tipo cliente
      if params[:ruc].to_s.count('-').to_i == 0
        cliente = {
                      contribuyente: false,
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 2,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      documentoTipo: 1,
                      documentoNumero: params[:ruc],
                      email: pers.email
                  }
      else
        cliente = {
                      contribuyente: true,
                      ruc: params[:ruc],
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 1,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      tipoContribuyente: 1,
                      email: pers.email
                  }
      end


      data = {ch:  [{
                  tipoDocumento: 1,
                  establecimiento: lanz.doc_01,
                  serie: lanz.serie,
                  punto: lanz.doc_02.to_s.gsub(' ', ''),
                  numero: lanz.doc,
                  fecha: "#{params[:data].to_date.strftime("%Y-%m-%d")}T#{Time.now.strftime('%H:%M:%S')}",
                  tipoEmision: 1,
                  tipoTransaccion: 2,
                  tipoImpuesto: 1,
                  moneda: md,
                  condicionTipoCambio: condicionTipoCambio,
                  cambio: cambio,
                  cliente: cliente,
                  usuario: {
                      documentoTipo: 1,
                      documentoNumero: '7723670',
                      nombre: 'Mairon Daniel Centurion Brasil',
                      cargo: 'Vendedor'
                  },
                  factura: {
                      presencia: 1
                  },
                  condicion: cd_detalhe,
                  items: list_prods
              }]}


          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data[:ch].to_json
          request.body = data[:ch].to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          puts get_resp = JSON.parse(response.body)


          puts '-----------------======-----------------------------------------------------'
          puts get_resp['success']

          if get_resp['success'] == true




            lanz.update_attributes(cod_proc: params[:cod_proc],
                         sigla_proc: params[:sigla_proc],
                         data: params[:data],
                         status: params[:status],
                         tipo: params[:tipo],
                         ruc: params[:ruc],
                         persona_nome: params[:persona_nome],
                         persona_id: params[:persona_id],
                         cota: params[:cota],
                         tipo_op: params[:tipo_op],
                         moeda: params[:moeda],
                         cdc: get_resp["result"]["deList"].last["cdc"],
                         tot_gs: params[:tot_gs] )

            clientes = Cliente.where(tabela_id: params[:cod_proc], tabela: 'CONTRATOS')

            ct = Contrato.find_by_id(params[:cod_proc])
            #atulizar numero do documento
            ct.update_attributes(documento_numero: lanz.doc)

            seq = 0
            clientes.each do |vf|
              seq += 1
              vf.update_attributes(documento_numero: "#{lanz.doc}-#{seq}",
                                      documento_numero_01: lanz.doc_01,
                                      documento_numero_02: lanz.doc_02)
            end

          end

          return render :json => { :fe => get_resp }
    end
  end

  def cliente_update_ft

    lanz = FormFiscal.find_by_id(params[:busca]['doc'])
      if lanz.tipo_emissao.to_i == 0 #impresso
          lanz.update_attributes(cod_proc: params[:cod_proc],
                         sigla_proc: params[:sigla_proc],
                         data: params[:data],
                         status: params[:status],
                         tipo: params[:tipo],
                         ruc: params[:ruc],
                         persona_nome: params[:persona_nome],
                         persona_id: params[:persona_id],
                         cota: params[:cota],
                         tipo_op: params[:tipo_op],
                         moeda: params[:moeda],
                         tot_gs: params[:tot_gs] )

              venda = Cliente.find_by_id(params[:cod_proc])

              #atulizar numero do documento
              venda.update_attributes(documento_numero: lanz.doc,
                                      documento_numero_01: lanz.doc_01,
                                      documento_numero_02: lanz.doc_02)
        return render :json => { fe: {success: 'true'} }
      else #virtual

      pers = Persona.find_by_id(params[:persona_id])
      cl = Cliente.find_by_id(params[:cod_proc])
      ctz = Moeda.last
      contrato_servicos = ContratoServico.select('produto_id,quantidade,total_gs,total_us,unitario_gs, unitario_us,obs').where(contrato_id: cl.cod_proc)

      if params[:moeda].to_i == 1
        md = 'PYG'
        condicionTipoCambio = "null"
        cambio = "null"
        monto = contrato_servicos.sum('total_gs').to_i
        monedaDescripcion = 'Guarani'
      else
        md = 'USD'
        condicionTipoCambio = 1
        cambio = ctz.dolar_venda
        monto = contrato_servicos.sum('total_us').to_f
        monedaDescripcion = 'Dolar'
      end

        list_prods = []

        contrato_servicos.each do |cs|

          if params[:moeda].to_i == 1
            precioUnitario = cs.unitario_gs.to_i
          else
            precioUnitario = cs.unitario_us.to_f
          end
          list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
            descripcion: cs.produto.nome,
            observacion: cs.obs,
            unidadMedida: cs.produto.unidade_medida_id,
            cantidad: cs.quantidade,
            precioUnitario: precioUnitario,
            ivaTipo: 1,
            ivaBase: 100,
            iva: cs.produto.taxa.to_i}]
        end


      #condição
      if params[:tipo].to_i == 0
        cd_detalhe =  {tipo: 1, entregas: [{
            tipo: 1,
            monto: monto,
            moneda: md,
            monedaDescripcion: monedaDescripcion,
            cambio: cambio
        }]}

      elsif params[:tipo].to_i == 1
        cd_detalhe = { tipo: 2, credito: {
          tipo: 1,
          plazo: "30 días",
          cuotas: 1,
          infoCuotas: [{
              moneda: "PYG",
              monto: monto,
              vencimiento: params[:data].to_date + 30
          }]
      }}
      end


      #tipo cliente
      if params[:ruc].to_s.count('-').to_i == 0
        cliente = {
                      contribuyente: false,
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 2,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      documentoTipo: 1,
                      documentoNumero: params[:ruc],
                      email: pers.email
                  }
      else
        cliente = {
                      contribuyente: true,
                      ruc: params[:ruc],
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 1,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      tipoContribuyente: 1,
                      email: pers.email
                  }
      end


      data = {ch:  [{
                  tipoDocumento: 1,
                  establecimiento: 1,
                  serie: lanz.serie,
                  punto: lanz.doc_02.to_s.gsub(' ', ''),
                  numero: lanz.doc,
                  fecha: "#{params[:data].to_date.strftime("%Y-%m-%d")}T#{Time.now.strftime('%H:%M:%S')}",
                  tipoEmision: 1,
                  tipoTransaccion: 2,
                  tipoImpuesto: 1,
                  moneda: md,
                  condicionTipoCambio: condicionTipoCambio,
                  cambio: cambio,
                  cliente: cliente,
                  usuario: {
                      documentoTipo: 1,
                      documentoNumero: '7723670',
                      nombre: 'Mairon Daniel Centurion Brasil',
                      cargo: 'Vendedor'
                  },
                  factura: {
                      presencia: 1
                  },
                  condicion: cd_detalhe,
                  items: list_prods
              }]}


          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data[:ch].to_json
          request.body = data[:ch].to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          puts get_resp = JSON.parse(response.body)


          puts '-----------------======-----------------------------------------------------'
          puts get_resp['success']

          if get_resp['success'] == true

            lanz.update_attributes(cod_proc: params[:cod_proc],
                         sigla_proc: params[:sigla_proc],
                         data: params[:data],
                         status: params[:status],
                         tipo: params[:tipo],
                         ruc: params[:ruc],
                         persona_nome: params[:persona_nome],
                         persona_id: params[:persona_id],
                         cota: params[:cota],
                         tipo_op: params[:tipo_op],
                         moeda: params[:moeda],
                         cdc: get_resp["result"]["deList"].last["cdc"],
                         tot_gs: params[:tot_gs] )

              venda = Cliente.find_by_id(params[:cod_proc])

              #atulizar numero do documento
              venda.update_attributes(documento_numero: lanz.doc,
                                      documento_numero_01: lanz.doc_01,
                                      documento_numero_02: lanz.doc_02)
          end

          return render :json => { :fe => get_resp }
    end
  end

  def cobro_update_nc
    lanz = FormFiscal.find_by_id(params[:busca]['doc'])

    if lanz.tipo_emissao.to_i == 1

      pers = Persona.find_by_id(params[:persona_id])
      ctz = Moeda.last

      fatura_associada = CobrosDetalhe.all(:conditions => ["desconto_guarani > 0 and cobro_id = ?", params[:cod_proc]]).last

      form_fiscal_find = FormFiscal.where("persona_id = #{params[:persona_id]} and tipo_doc = 1 and doc_01 = '#{fatura_associada.documento_numero_01}' and doc_02 = '#{fatura_associada.documento_numero_02.to_s.gsub(' ', '')}' and doc = '#{fatura_associada.documento_numero}' ").last


      if form_fiscal_find.tipo_emissao.to_i == 0 #impresso
        doc = {
                formato: 2,
                tipoDocumentoImpreso: 1,
                timbrado: form_fiscal_find.timbrado,
                establecimiento: form_fiscal_find.doc_01,
                punto: form_fiscal_find.doc_02,
                numero: form_fiscal_find.doc,
                fecha: form_fiscal_find.data
            }
      else
        doc = { formato: 1,
              cdc: form_fiscal_find.cdc
            }
      end


      if params[:moeda].to_i == 1
        md = 'PYG'
        condicionTipoCambio = "null"
        cambio = "null"
        monto = params[:tot_gs].to_i
        monedaDescripcion = 'Guarani'
      else
        md = 'USD'
        condicionTipoCambio = 1
        cambio = ctz.dolar_venda
        monto = params[:tot_us].to_i
        monedaDescripcion = 'Dolar'
      end
        list_prods = []

          if params[:taxa].to_i == 0
            iva_tipo = 3
            iva_base = 0
            iva = 0
          elsif params[:taxa].to_i == 5
            iva_tipo = 1
            iva_base = 100
            iva = 5
          elsif params[:taxa].to_i == 10
            iva_tipo = 1
            iva_base = 100
            iva = 10
          elsif params[:taxa].to_i == 70
            iva_tipo = 4
            iva_base = 30
            iva = 10
          end

          if params[:moeda].to_i == 1
            precioUnitario = params[:tot_gs].to_i
          else
            precioUnitario = params[:tot_us].to_i
          end
          list_prods  += [{codigo: '1'.to_s.rjust(6,'0'),
            descripcion: "Diferencia de Precio Factura Nro.: #{form_fiscal_find.doc_01}-#{form_fiscal_find.doc_02}-#{form_fiscal_find.doc}",
            unidadMedida: 77,
            cantidad: 1,
            precioUnitario: precioUnitario,
            ivaTipo: iva_tipo,
            ivaBase: iva_base,
            iva: iva}]


      #condição
      if params[:tipo].to_i == 0
        cd_detalhe =  {tipo: 1, entregas: [{
            tipo: 1,
            monto: monto,
            moneda: md,
            monedaDescripcion: monedaDescripcion,
            cambio: cambio
        }]}

      elsif params[:tipo].to_i == 1
        cd_detalhe = { tipo: 2, credito: {
          tipo: 1,
          plazo: "30 días",
          cuotas: 1,
          infoCuotas: [{
              moneda: "PYG",
              monto: monto,
              vencimiento: params[:data].to_date + 30
          }]
      }}
      end


      #tipo cliente
      if params[:ruc].to_s.count('-').to_i == 0
        cliente = {
                      contribuyente: false,
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:nc_persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 2,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      documentoTipo: 1,
                      documentoNumero: params[:ruc],
                      email: pers.email
                  }
      else
        cliente = {
                      contribuyente: true,
                      ruc: params[:ruc],
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:nc_persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 1,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      tipoContribuyente: 1,
                      email: pers.email
                  }
      end


      data = {ch:  [{
                  tipoDocumento: 5,
                  establecimiento: lanz.doc_01,
                  serie: lanz.serie,
                  punto: lanz.doc_02,
                  numero: lanz.doc,
                  fecha: "#{params[:data].to_date.strftime("%Y-%m-%d")}T#{Time.now.strftime('%H:%M:%S')}",
                  tipoEmision: 1,
                  tipoTransaccion: 2,
                  tipoImpuesto: 1,
                  moneda: md,
                  condicionTipoCambio: condicionTipoCambio,
                  cambio: cambio,
                  cliente: cliente,
                  usuario: {
                      documentoTipo: 1,
                      documentoNumero: '7723670',
                      nombre: 'Mairon Daniel Centurion Brasil',
                      cargo: 'Vendedor'
                  },
                  notaCreditoDebito: {
                      motivo: 3
                  },
                  items: list_prods,
                  documentoAsociado: doc
              }]}


            url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(url)
            request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
            request["content-type"] = 'application/json'
            # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
            puts data[:ch].to_json
            request.body = data[:ch].to_json
            puts '----------------------------------------------------------------------'
            response = http.request(request)
            puts get_resp = JSON.parse(response.body)

    end

    if get_resp['success'] == true
      lanz.update_attributes(cod_proc: params[:cod_proc],
                             sigla_proc: params[:sigla_proc],
                             data: params[:data],
                             status: params[:status],
                             tipo: params[:tipo],
                             ruc: params[:ruc],
                             persona_nome: params[:persona_nome],
                             persona_id: params[:persona_id],
                             cota: params[:cota],
                             tipo_op: params[:tipo_op],
                             moeda: params[:moeda],
                             cdc: get_resp["result"]["deList"].last["cdc"],
                             tot_gs: params[:tot_gs] )
    end
    return render :json => { :fe => get_resp }
  end

  #fatura cobro
  def cobro_update_fc

    lanz = FormFiscal.find_by_id(params[:busca]['doc'])

      if lanz.tipo_emissao.to_i == 0 #impresso

        lanz.update_attributes(cod_proc: params[:cod_proc],
                               sigla_proc: params[:sigla_proc],
                               data: params[:data],
                               status: params[:status],
                               tipo: params[:tipo],
                               ruc: params[:ruc],
                               persona_nome: params[:persona_nome],
                               persona_id: params[:persona_id],
                               produto_id: params[:busca]['produto_id'],
                               cota: params[:cota],
                               tipo_op: params[:tipo_op],
                               moeda: params[:moeda],
                               tot_gs: params[:tot_gs] )

        redirect_to cobro_final_cobro_path(lanz.cod_proc)


    else #virtual
      pers = Persona.find_by_id(params[:persona_id])
      ctz = Moeda.last
      venda = Cobro.find_by_id(params[:cod_proc])

      if params[:tot_gs].to_i > 0 # fatura interes interes
        if params[:moeda].to_i == 1
          md = 'PYG'
          condicionTipoCambio = "null"
          cambio = "null"
          monto = params[:tot_gs].to_i
          monedaDescripcion = 'Guarani'
          desconto_global =  0
        else
          md = 'USD'
          condicionTipoCambio = 1
          cambio = venda.cotacao.to_i
          monto = params[:tot_us].to_f
          monedaDescripcion = 'Dolar'
          desconto_global = 0
        end

          list_prods = []
          if params[:moeda].to_i == 1
            precioUnitario = params[:tot_gs].to_i
          else
            precioUnitario = params[:tot_us].to_f
          end
          list_prods  += [{codigo: 9999.to_s.rjust(6,'0'),
            descripcion: 'INTERES',
            unidadMedida: 77,
            cantidad: 1,
            precioUnitario: precioUnitario,
            ivaTipo: 1,
            ivaBase: 100,
            iva: 10}]

      else #fatura vendas não faturadas

        vd = venda.cobros_detalhes.where("venda_id is not null").count(:id)

        if vd.to_i > 0
          list_ids = venda.cobros_detalhes.where("venda_id is not null").map  { |t| t.venda_id }.join(', ')
        else
          list_ids = 0
        end

        cl = venda.cobros_detalhes.where("venda_id is null").count(:id)

        if cl.to_i > 0
          list_cl_ids = venda.cobros_detalhes.where("venda_id is null").map { |t| "#{t.documento_numero}#{t.cota}" }.join("','")
        else
          list_cl_ids = 0
        end


 sql = "

            SELECT
                 VVP.DESCRICAO AS PRODUTO_NOME,
                 VVP.COTA,
                 MAX(VVP.ID) AS PRODUTO_ID,
                 COUNT(VP.DOCUMENTO_NUMERO) AS QUANTIDADE,
                 MAX(VP.MOEDA) AS MOEDA,
                 ((SUM(VP.COBRO_GUARANI)/ COUNT(VP.DOCUMENTO_NUMERO))  ) AS UNITARIO_GUARANI,
                 (SUM(VP.COBRO_GUARANI)) AS TOTAL_GUARANI,
                 SUM(VP.COBRO_DOLAR) AS UNITARIO_DOLAR,
                 SUM(VP.COBRO_DOLAR) AS TOTAL_DOLAR,
                 MAX(VP.SALDO_PERC) AS SP,

                 MAX(VVP.TAXA) AS TAXA
                 FROM COBROS_DETALHES VP
                 INNER JOIN CLIENTES VVP
                 ON VVP.PERSONA_ID = VP.PERSONA_ID and VVP.divida_guarani > 0 and VVP.documento_numero = VP.documento_numero and VVP.cota = VP.cota AND VP.VENDA_ID IS NULL

                 WHERE VP.COBRO_ID = #{venda.id} AND VP.VENDA_ID IS NULL
                 GROUP BY 1,2"

  venda_produto = VendasProduto.find_by_sql(sql)

 sql = "
            SELECT
                 VVP.PRODUTO_NOME,
                 MAX(VVP.PRODUTO_ID) AS PRODUTO_ID,
                 SUM(VVP.QUANTIDADE) AS QUANTIDADE,
                 MAX(VP.MOEDA) AS MOEDA,
                 (SUM(VVP.TOTAL_GUARANI - VVP.DESCONTO_GUARANI) / SUM(VVP.QUANTIDADE) * MAX(VP.SALDO_PERC / 100) / (SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID= MAX(VP.VENDA_ID) ))  AS UNITARIO_GUARANI,
                 (SUM(VVP.TOTAL_GUARANI - VVP.DESCONTO_GUARANI) * MAX(VP.SALDO_PERC / 100) / (SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = MAX(VP.VENDA_ID) )) AS TOTAL_GUARANI,
                 SUM(VP.COBRO_DOLAR) AS UNITARIO_DOLAR,
                 SUM(VP.COBRO_DOLAR) AS TOTAL_DOLAR,

                 MAX(P.TAXA) AS TAXA

                 FROM COBROS_DETALHES VP

                 INNER JOIN VENDAS_PRODUTOS VVP
                 ON VVP.VENDA_ID = VP.VENDA_ID

                 INNER JOIN PRODUTOS P
                 ON P.ID = VVP.PRODUTO_ID

                 WHERE COBRO_ID = #{venda.id} AND VP.VENDA_ID IS NOT NULL
                 GROUP BY 1"


      venda_produto_dt = VendasProduto.find_by_sql(sql)

 end

        list_prods = []
        tot_monto_gs = 0
        venda_produto_dt.each do |cs|
          tot_monto_gs += (cs.unitario_guarani.to_i * cs.quantidade.to_i)
          iva_tipo = 1
          iva_base = 100

          if cs.taxa.to_i == 0
            iva_tipo = 3
            iva_base = 0
            iva = 0
          elsif cs.taxa.to_i == 5
            iva_tipo = 1
            iva_base = 100
            iva = 5
          elsif cs.taxa.to_i == 10
            iva_tipo = 1
            iva_base = 100
            iva = 10
          elsif cs.taxa.to_i == 70
            iva_tipo = 4
            iva_base = 30
            iva = 10
          end

          if params[:moeda].to_i == 1
            precioUnitario = cs.unitario_guarani.to_i
          else
            precioUnitario = cs.unitario_dolar.to_f
          end

          list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
            descripcion: cs.produto_nome,
            unidadMedida: 77,
            cantidad: cs.quantidade.to_f,
            precioUnitario: precioUnitario,
            ivaTipo: iva_tipo,
            ivaBase: iva_base,
            iva: iva}]
        end

      #------

        venda_produto.each do |cs|
          tot_monto_gs += (cs.unitario_guarani.to_i * cs.quantidade.to_i)
          iva_tipo = 1
          iva_base = 100

          if cs.taxa.to_i == 0
            iva_tipo = 3
            iva_base = 0
            iva = 0
          elsif cs.taxa.to_i == 5
            iva_tipo = 1
            iva_base = 100
            iva = 5
          elsif cs.taxa.to_i == 10
            iva_tipo = 1
            iva_base = 100
            iva = 10
          elsif cs.taxa.to_i == 70
            iva_tipo = 4
            iva_base = 30
            iva = 10
          end

          if params[:moeda].to_i == 1
            precioUnitario = cs.unitario_guarani.to_i
          else
            precioUnitario = cs.unitario_dolar.to_f
          end

          list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
            descripcion: cs.produto_nome,
            unidadMedida: 77,
            cantidad: cs.quantidade.to_f,
            precioUnitario: precioUnitario,
            ivaTipo: iva_tipo,
            ivaBase: iva_base,
            iva: iva}]
        end


        if params[:moeda].to_i == 1
          md = 'PYG'
          condicionTipoCambio = "null"
          cambio = "null"
          monto = tot_monto_gs.to_i
          monedaDescripcion = 'Guarani'
          desconto_global =  0
        else
          md = 'USD'
          condicionTipoCambio = 1
          cambio = venda.cotacao.to_i
          monto = params[:tot_us].to_f
          monedaDescripcion = 'Dolar'
          desconto_global = 0
        end


      #condição
      cd_detalhe =  {tipo: 1, entregas: [{
          tipo: 1,
          monto: monto,
          moneda: md,
          monedaDescripcion: monedaDescripcion,
          cambio: cambio
      }]}

      #tipo cliente
      if params[:ruc].to_s.gsub('.', '').count('-').to_i == 0
        cliente = {
                      contribuyente: false,
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 2,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      documentoTipo: 1,
                      documentoNumero: params[:ruc],
                      email: pers.email
                  }
      else
        cliente = {
                      contribuyente: true,
                      ruc: params[:ruc],
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 1,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      tipoContribuyente: 2,
                      email: pers.email
                  }
      end


      data = {ch:  [{
                  tipoDocumento: 1,
                  establecimiento: lanz.doc_01,
                  serie: lanz.serie,
                  punto: lanz.doc_02.to_s.gsub(' ', ''),
                  numero: lanz.doc,
                  fecha: "#{params[:data].to_date.strftime("%Y-%m-%d")}T#{Time.now.strftime('%H:%M:%S')}",
                  tipoEmision: 1,
                  tipoImpuesto: 1,
                  moneda: md,
                  condicionTipoCambio: condicionTipoCambio,
                  descuentoGlobal: desconto_global,
                  cambio: cambio,
                  cliente: cliente,
                  observacion: "Chronos Software",
                  usuario: {
                      documentoTipo: 1,
                      documentoNumero: '157264',
                      nombre: 'Marcos Jara',
                      cargo: 'Vendedor'
                  },
                  factura: {
                      presencia: 1
                  },
                  condicion: cd_detalhe,
                  items: list_prods
              }]}


          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data[:ch].to_json
          request.body = data[:ch].to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          puts get_resp = JSON.parse(response.body)

          puts '-----------------======-----------------------------------------------------'
          puts get_resp['success']

          if get_resp['success'] == true

            lanz.update_attributes(cod_proc: params[:cod_proc],
                             sigla_proc: params[:sigla_proc],
                             data: params[:data],
                             status: params[:status],
                             tipo: params[:tipo],
                             ruc: params[:ruc],
                             persona_nome: params[:persona_nome],
                             persona_id: params[:persona_id],
                             produto_id: params[:produto_id],
                             cota: params[:cota],
                             tipo_op: params[:tipo_op],
                             moeda: params[:moeda],
                             cdc: get_resp["result"]["deList"].last["cdc"],
                             tot_gs: params[:tot_gs],
                             tot_us: params[:tot_us] )

          end

          return render :json => { :fe => get_resp }

    end
  end


  def cobro_update_rd
    lanz = FormFiscal.find_by_id(params[:busca]['doc'])
    lanz.update_attributes(cod_proc: params[:cod_proc],
                           sigla_proc: params[:sigla_proc],
                           data: params[:data],
                           status: params[:status],
                           tipo: params[:tipo],
                           ruc: params[:ruc],
                           persona_nome: params[:persona_nome],
                           persona_id: params[:persona_id],
                           produto_id: params[:busca]['produto_id'],
                           cota: params[:cota],
                           tipo_op: params[:tipo_op],
                           moeda: params[:moeda],
                           tot_gs: params[:tot_gs] )

    cobro_fin = CobrosFinanca.where(cobro_id: params[:cod_proc])
    cobro_fin.each do |cf|
      cf.update_attributes(documento_numero_01: lanz.doc_01,
        documento_numero_02: lanz.doc_02,
        documento_numero: lanz.doc, numero_recibo: lanz.doc)
    end

    redirect_to cobro_final_cobro_path(lanz.cod_proc)
  end

  def adelanto_update_rd
    lanz = FormFiscal.find_by_id(params[:busca]['doc'])
    lanz.update_attributes(cod_proc: params[:cod_proc],
                           sigla_proc: params[:sigla_proc],
                           data: params[:data],
                           status: params[:status],
                           tipo: params[:tipo],
                           ruc: params[:ruc],
                           persona_nome: params[:persona_nome],
                           persona_id: params[:persona_id],
                           produto_id: params[:busca]['produto_id'],
                           cota: params[:cota],
                           tipo_op: params[:tipo_op],
                           moeda: params[:moeda],
                           tot_gs: params[:tot_gs] )



      ad = Adelanto.find_by_id(lanz.cod_proc)

      #atulizar numero do documento
      ad.update_attributes(documento_numero: params[:sigla_proc])

    redirect_to adelanto_path(lanz.cod_proc)
  end


  def nota_cred_update_nc #venda
    lanz = FormFiscal.find_by_id(params[:busca]['doc'])


    if lanz.tipo_emissao.to_i == 1

      pers = Persona.find_by_id(params[:persona_id])
      ctz = Moeda.last

      nc = NotaCredito.find_by_id(params[:cod_proc])

      if nc.origem_proc.to_i == 0  #venda

        if nc.fiscal == 0 #fatura feita no cobro
          cd = CobrosDetalhe.where(venda_id: nc.documento_id).last
          unless cd.blank?
            ff =  FormFiscal.where(sigla_proc: 'CB', cod_proc: cd.cobro_id).last
            contrato_servicos = NotaCreditosDetalhe.select('produto_id,quantidade,total_guarani,total_dolar,unitario_guarani, unitario_dolar').where(nota_credito_id: nc.id)
          end

        else #fatura feita na venda
          ff = FormFiscal.where(id: nc.documento_id, sigla_proc: 'VT').last
          contrato_servicos = NotaCreditosDetalhe.select('produto_id,quantidade,total_guarani,total_dolar,unitario_guarani, unitario_dolar').where(venda_id: ff.cod_proc)
        end

        if params[:moeda].to_i == 1
          md = 'PYG'
          condicionTipoCambio = "null"
          cambio = "null"
          monto = contrato_servicos.sum('total_guarani').to_i
          monedaDescripcion = 'Guarani'
        else
          md = 'USD'
          condicionTipoCambio = 1
          cambio = ctz.dolar_venda
          monto = contrato_servicos.sum('total_dolar').to_f
          monedaDescripcion = 'Dolar'
        end

          list_prods = []

          contrato_servicos.each do |cs|

          iva_tipo = 1
          iva_base = 100

          if cs.produto.taxa.to_i == 0
            iva_tipo = 3
            iva_base = 0
            iva = 0
          elsif cs.produto.taxa.to_i == 5
            iva_tipo = 1
            iva_base = 100
            iva = 5
          elsif cs.produto.taxa.to_i == 10
            iva_tipo = 1
            iva_base = 100
            iva = 10
          elsif cs.produto.taxa.to_i == 70
            iva_tipo = 4
            iva_base = 30
            iva = 10
          end

          if cs.produto.embalagem == 'LT'
            unidade_medido = 89
          else
            unidade_medido = 77
          end

            if params[:moeda].to_i == 1
              precioUnitario = cs.unitario_guarani.to_i
            else
              precioUnitario = cs.unitario_dolar.to_f
            end
            list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
              descripcion: cs.produto.nome,
              observacion: '',
              unidadMedida: unidade_medido,
              cantidad: cs.quantidade,
              precioUnitario: precioUnitario,
              ivaTipo: iva_tipo,
              ivaBase: iva_base,
              iva: iva}]
          end

      else  #contrato
        ff = FormFiscal.where(id: nc.documento_id).last
        cl = Cliente.where(id: ff.cod_proc).last

        contrato_servicos = ContratoServico.select('produto_id,quantidade,total_gs,total_us,unitario_gs, unitario_us,obs').where(contrato_id: cl.cod_proc)

        if params[:moeda].to_i == 1
          md = 'PYG'
          condicionTipoCambio = "null"
          cambio = "null"
          monto = contrato_servicos.sum('total_gs').to_i
          monedaDescripcion = 'Guarani'
        else
          md = 'USD'
          condicionTipoCambio = 1
          cambio = ctz.dolar_venda
          monto = contrato_servicos.sum('total_us').to_f
          monedaDescripcion = 'Dolar'
        end

          list_prods = []

          contrato_servicos.each do |cs|

            if params[:moeda].to_i == 1
              precioUnitario = cs.unitario_gs.to_i
            else
              precioUnitario = cs.unitario_us.to_f
            end
            list_prods  += [{codigo: cs.produto_id.to_s.rjust(6,'0'),
              descripcion: cs.produto.nome,
              observacion: cs.obs,
              unidadMedida: 77,
              cantidad: cs.quantidade,
              precioUnitario: precioUnitario,
              ivaTipo: 1,
              ivaBase: 100,
              iva: cs.produto.taxa.to_i}]
          end

      end

      #condição
      if params[:tipo].to_i == 0
        cd_detalhe =  {tipo: 1, entregas: [{
            tipo: 1,
            monto: monto,
            moneda: md,
            monedaDescripcion: monedaDescripcion,
            cambio: cambio
        }]}

      elsif params[:tipo].to_i == 1
        cd_detalhe = { tipo: 2, credito: {
          tipo: 1,
          plazo: "30 días",
          cuotas: 1,
          infoCuotas: [{
              moneda: "PYG",
              monto: monto,
              vencimiento: params[:data].to_date + 30
          }]
      }}
      end


      #tipo cliente
      if params[:ruc].to_s.count('-').to_i == 0
        cliente = {
                      contribuyente: false,
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 2,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      documentoTipo: 1,
                      documentoNumero: params[:ruc],
                      email: pers.email
                  }
      else
        cliente = {
                      contribuyente: true,
                      ruc: params[:ruc],
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 1,
                      direccion: pers.direcao,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      tipoContribuyente: 1,
                      email: pers.email
                  }
      end


      data = {ch:  [{
                  tipoDocumento: 5,
                  establecimiento: 1,
                  serie: lanz.serie,
                  punto: lanz.doc_02,
                  numero: lanz.doc,
                  fecha: "#{params[:data].to_date.strftime("%Y-%m-%d")}T#{Time.now.strftime('%H:%M:%S')}",
                  tipoEmision: 1,
                  tipoTransaccion: 2,
                  tipoImpuesto: 1,
                  moneda: md,
                  condicionTipoCambio: condicionTipoCambio,
                  cambio: cambio,
                  cliente: cliente,
                  usuario: {
                      documentoTipo: 1,
                      documentoNumero: '7723670',
                      nombre: 'Mairon Daniel Centurion Brasil',
                      cargo: 'Vendedor'
                  },
                  notaCreditoDebito: {
                      motivo: nc.motivo
                  },
                  items: list_prods,
                  documentoAsociado: {
                      formato: 1,
                      cdc: ff.cdc
                  }
              }]}


          url = URI("https://api.facturasend.com.py/#{current_unidade.nome_api_fiscal}/lote/create")

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["authorization"] = "Bearer api_key_#{current_unidade.token_api}"
          request["content-type"] = 'application/json'
          # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
          puts data[:ch].to_json
          request.body = data[:ch].to_json
          puts '----------------------------------------------------------------------'
          response = http.request(request)
          puts get_resp = JSON.parse(response.body)


          puts '-----------------======-----------------------------------------------------'
          puts get_resp['success']

    end

          if get_resp['success'] == true

                lanz.update_attributes(cod_proc: params[:cod_proc],
                           sigla_proc: params[:sigla_proc],
                           data: params[:data],
                           status: params[:status],
                           tipo: params[:tipo],
                           ruc: params[:ruc],
                           persona_nome: params[:persona_nome],
                           persona_id: params[:persona_id],
                           cota: params[:cota],
                           tipo_op: params[:tipo_op],
                           moeda: params[:moeda],
                           cdc: get_resp["result"]["deList"].last["cdc"],
                           tot_gs: params[:tot_gs] )

            venda = NotaCredito.find_by_id(params[:cod_proc])
            #atulizar numero do documento
            venda.update_attributes(documento_numero: lanz.doc,
                                    documento_numero_01: lanz.doc_01,
                                    documento_numero_02: lanz.doc_02)
          end

          return render :json => { :fe => get_resp }

  end

  def gera_docs
    inicio = params[:doc_inicio].to_i
    final  = params[:doc_final].to_i
    sequencia = inicio
    (inicio..final).each do |i|

      FormFiscal.create(  tipo_doc: params[:e_tipo],
                          timbrado: params[:timbrado],
                          tipo_emissao: params[:tipo_emissao],
                          vencimento: params[:vencimento],
                          doc_01: params[:doc_01],
                          doc_02: params[:doc_02],
                          doc: sequencia,
                          status: 0,
                          unidade_id: params[:unidade_id],
                          terminal_id: params[:busca]["terminal"]
                        )

      sequencia += 1
    end
    redirect_to form_fiscals_path
  end

  def index
    render layout: 'chart'
  end

  def busca
    st   = "AND FF.STATUS = #{params[:status]}" unless params[:status].blank?
    te   = "AND FF.TIPO_EMISSAO = #{params[:tipo_emissao]}" unless params[:tipo_emissao].blank?
    doc  = "AND ( COALESCE(FF.DOC, ' ') || ' ' || COALESCE(FF.PERSONA_NOME, ' ') || '' || COALESCE(FF.CDC,' ') ) ILIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    data = "AND FF.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?
    sql  = "SELECT FF.ID,
                 FF.UNIDADE_ID,
                 FF.TERMINAL_ID,
                 FF.VENCIMENTO,
                 FF.DATA,
                 FF.DOC_01,
                 FF.DOC_02,
                 FF.DOC,
                 FF.STATUS,
                 FF.TIPO_DOC,
                 FF.RUC,
                 FF.PERSONA_NOME,
                 FF.SIGLA_PROC,
                 FF.COD_PROC,
                 FF.TIMBRADO,
                 FF.TIPO,
                 FF.CDC
          FROM FORM_FISCALS FF
          WHERE FF.UNIDADE_ID = #{current_unidade.id}
          AND FF.TIPO_DOC = #{params[:e_tipo]}
          #{te} #{st} #{doc} #{data}
          ORDER BY FF.DATA, CAST(FF.DOC AS INTEGER)
"
    @form_fiscals = FormFiscal.paginate_by_sql(sql, page: params[:page], :per_page => 25)
    respond_to do |format|
        format.html { render :layout => false}
    end
  end

    def print
    st   = "AND FF.STATUS = #{params[:status]}" unless params[:status].blank?
    doc  = "AND FF.DOC LIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    data = "AND FF.DATA BETWEEN '#{params[:inicio]}' and '#{params[:final]}'" unless params[:inicio].blank?
    sql  = "SELECT FF.ID,
                 FF.UNIDADE_ID,
                 FF.TERMINAL_ID,
                 FF.VENCIMENTO,
                 FF.DATA,
                 FF.DOC_01,
                 FF.DOC_02,
                 FF.DOC,
                 FF.STATUS,
                 FF.TIPO_DOC,
                 FF.RUC,
                 FF.PERSONA_NOME,
                 FF.SIGLA_PROC,
                 FF.COD_PROC,
                 FF.TIMBRADO,
                 FF.TIPO
          FROM FORM_FISCALS FF
          WHERE FF.UNIDADE_ID = #{current_unidade.id}
          AND FF.TIPO_DOC = #{params[:tipo_doc]}
          #{st} #{doc} #{data}
"
    @form_fiscals = FormFiscal.find_by_sql(sql)
        head =
        "                                                   #{$empresa_nome}
                                                            FORMULARIOS FISCALES
- Fecha : #{params[:inicio]} HASTA #{params[:final]}

        "

        respond_to do |format|
          format.html do
            render  :pdf                    => "print",
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '1.20in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                    :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :left       => head,
                                :spacing    => 25},
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
      end

  def form_anula_nc
    @form_fiscal = FormFiscal.find(params[:id])
  end

  def show
    @form_fiscal = FormFiscal.find(params[:id])
    render layout: 'chart'
  end

  # GET /form_fiscals/new
  # GET /form_fiscals/new.json
  def new
    @form_fiscal = FormFiscal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @form_fiscal }
    end
  end

  # GET /form_fiscals/1/edit
  def edit
    @form_fiscal = FormFiscal.find(params[:id])
  end

  # POST /form_fiscals
  # POST /form_fiscals.json
  def create
    @form_fiscal = FormFiscal.new(params[:form_fiscal])

    respond_to do |format|
      if @form_fiscal.save
        format.html { redirect_to @form_fiscal, notice: 'Form fiscal was successfully created.' }
        format.json { render json: @form_fiscal, status: :created, location: @form_fiscal }
      else
        format.html { render action: "new" }
        format.json { render json: @form_fiscal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /form_fiscals/1
  # PUT /form_fiscals/1.json
  def update
    @form_fiscal = FormFiscal.find(params[:id])

    respond_to do |format|
      if @form_fiscal.update_attributes(params[:form_fiscal])
        format.html { redirect_to @form_fiscal, notice: 'Form fiscal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @form_fiscal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_fiscals/1
  # DELETE /form_fiscals/1.json
  def destroy
    @form_fiscal = FormFiscal.find(params[:id])
    @form_fiscal.destroy

    respond_to do |format|
      format.html { redirect_to form_fiscals_url }
      format.json { head :no_content }
    end
  end
end

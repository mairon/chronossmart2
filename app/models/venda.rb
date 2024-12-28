class Venda < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :clientes,          :order => 1
  has_many :vendas_produtos,   :order => 1, :dependent => :destroy
  has_many :vendas_financas,   :order => 1, :dependent => :destroy
  has_many :vendas_pedidos,   :order => 1, :dependent => :destroy
  has_many :venda_romaneios,   :order => 1, :dependent => :destroy
  has_many :vendas_ordem_servs,   :order => 1, :dependent => :destroy
  has_many :venda_devolucaos,   :order => 1, :dependent => :destroy
  has_many :vendas_faturas
  has_many :venda_compras
  has_many :evento_convidados
  belongs_to :persona
  belongs_to :terminal
  belongs_to :usuario
  belongs_to :turno
  belongs_to :cidade
  belongs_to :cartao
  belongs_to :tabela_preco
  belongs_to :plano_venda

  before_save :finds

  validates_presence_of :persona_id, :tabela_preco_id, :moeda, :tipo_venda
  validate  :block_cliente
  before_destroy :destroy_cartao

  def destroy_cartao
    cartao.update_attributes(status_op: 0) unless cartao.nil?
    cartao.update_attributes(venda_id: 0) unless cartao.nil?
  end

  def block_cliente
    #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
    if ( persona.estado.to_i == 1  )
      errors.add( :persona_id,"Cliente Bloqueado Consulte a Parte Administrativa" )
    end
  end

  def pendencia_cliente
    #divida > que 90 dias
    dividas = Cliente.count(:id, :conditions => ["PERSONA_ID = ? AND LIQUIDACAO = 0 AND ( CURRENT_DATE - (VENCIMENTO + 90) ) >= 90",self.persona_id])

    if (dividas.to_i >  0  )
      errors.add(:persona_id, "Cliente Bloqueado Por Pendencias con Mas 90 Dias, Consulte la Parte Administrativa" )
    end
  end


  def self.gerador_cotas(params)
    forma_de_pagamento = FormaPago.find_by_id(params[:forma_pg])
    venda = Venda.find_by_id(params[:id])
    ct = 0 + (VendasFinanca.count(:id, :conditions => ["venda_id = #{params[:id]}"]).to_i)
    #transformacao das cotacaos
    if params[:moeda].to_s == '0'
      if params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f > params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        if params[:vuelto].to_f > 0 
          vuel_gs = params[:vuelto].to_s.gsub('.', '').gsub(',', '.').to_f
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        end

        val_us = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao.to_i
        val_rs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao_rs_us.to_f
        val_ps = 0

      elsif params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f < params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao.to_i
        val_rs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao_rs_us.to_f
        val_ps = 0

      elsif params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f == params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f

        val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      end

    elsif params[:moeda].to_s == '1'
      if params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f > params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f

        if params[:vuelto].to_f > 0
          vuel_gs = params[:vuelto].to_s.gsub('.', '').gsub(',', '.').to_f
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        end

        val_us = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao.to_f
        val_gs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_real.to_i

      elsif params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f < params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f

        val_us = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao.to_f
        val_gs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_real.to_i

      elsif params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f == params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      end

    elsif params[:moeda].to_s == '2'
      if params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f > params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        if params[:vuelto].to_f > 0
          vuel_gs = params[:vuelto].to_s.gsub('.', '').gsub(',', '.').to_f
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        end

        val_us = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_rs_us.to_f
        val_gs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_real.to_i
        val_rs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      elsif params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f < params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_rs_us.to_f
        val_gs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_real.to_i
        val_rs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      elsif params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f == params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      end
		elsif params[:moeda].to_s == '3'
      if params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f >= params[:valor_sem_ps].to_f
        if params[:vuelto].to_f > 0
          val_ps = params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f
          val_gs = (params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_gs_ps.to_f)
          val_rs = (val_gs.to_f / venda.cotacao_real.to_f)
          val_us = (val_gs.to_f / venda.cotacao.to_f)

          vuel_gs = ((params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_gs_ps.to_f).to_f - params[:valor_sem_gs].to_i)
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        else

          val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
          val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
          val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
          val_ps = params[:valor_sem_ps].to_s.gsub('.', '').gsub(',', '.').to_f
        end
      else
      	val_gs = (params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_gs_ps.to_i)
        val_us = (val_gs.to_f / venda.cotacao.to_f)
        val_rs = (val_gs.to_f / venda.cotacao_real.to_i)
        val_ps = params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f
      end
    end
    #forma de pagamento que afetam o caixa
    if forma_de_pagamento.tipo.to_i == 0

      if params[:forma_pg] == '15' #transf bancaria
        puts 'aquiiiii'
        VendasFinanca.create( :venda_id        => params[:id],
                                :forma_pago_id   => params[:forma_pg],
                                :cartao_bandeira_id => params[:busca]["cartao_bandeiras"],
                                :conta_id => params[:busca]["conta_id"],
                                :controle_caixa => params[:controle_caixa],
                                :tipo            => forma_de_pagamento.tipo,
                                :cheque_status   => params[:cheque_status],
                                :cheque          => params[:cheque],
                                :diferido        => params[:diferido],
                                :data            => venda.data,
                                :vencimento      => venda.data,
                                :cotacao         => venda.cotacao,
                                :fatura          => 0,
                                :vendedor_id     => venda.vendedor_id,
                                :documento_numero_01 => '000',
                                :documento_numero_02 => '000',
                                :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                                :moeda           => params[:moeda],
                                :cota            => 0,
                                :valor_dolar     => val_us.to_f,
                                :valor_guarani   => val_gs.to_f,
                                :valor_real      => val_rs.to_f,
                                :valor_peso      => val_ps.to_f,
                                :cred_deb        => 0,
                                :titular         => params[:titular],
                                :nr_comprovante  => params[:nr_comprovante],
                                :desconto        => params[:desc_gs].to_f,
                                :usuario_id      => params[:usuario_id],
                                  :fact_ad_01      => params[:fact_ad_01],
                                  :fact_ad_02      => params[:fact_ad_02],
                                  :fact_ad      => params[:fact_ad],
                                  :obs          => params[:obs]
               )
      else
        puts 'não aquiiii'
        VendasFinanca.create( :venda_id        => params[:id],
                                :forma_pago_id   => params[:forma_pg],
                                :cartao_bandeira_id => params[:busca]["cartao_bandeiras"],
                                :controle_caixa => params[:controle_caixa],
                                :tipo            => forma_de_pagamento.tipo,
                                :cheque_status   => params[:cheque_status],
                                :cheque          => params[:cheque],
                                :diferido        => params[:diferido],
                                :data            => venda.data,
                                :vencimento      => venda.data,
                                :cotacao         => venda.cotacao,
                                :fatura          => 0,
                                :vendedor_id     => venda.vendedor_id,
                                :documento_numero_01 => '000',
                                :documento_numero_02 => '000',
                                :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                                :moeda           => params[:moeda],
                                :cota            => ct,
                                :valor_dolar     => val_us.to_f,
                                :valor_guarani   => val_gs.to_f,
                                :valor_real      => val_rs.to_f,
                                :valor_peso      => val_ps.to_f,
                                :cred_deb        => 0,
                                :titular         => params[:titular],
                                :nr_comprovante  => params[:nr_comprovante],
                                :desconto        => params[:desc_gs].to_f,
                                :usuario_id      => params[:usuario_id],
                                  :fact_ad_01      => params[:fact_ad_01],
                                  :fact_ad_02      => params[:fact_ad_02],
                                  :fact_ad      => params[:fact_ad],
                                  :obs          => params[:obs]
               )

      end

    if params[:vuelto].to_f > 0 
      VendasFinanca.create( :venda_id        => params[:id],
                              :forma_pago_id   => 8,
                              :cartao_bandeira_id => 0,
                              :controle_caixa => params[:controle_caixa],
                              :tipo            => forma_de_pagamento.tipo,
                              :cheque_status   => 0,
                              :cheque          => '',
                              :diferido        => params[:diferido],
                              :data            => venda.data,
                              :vencimento      => venda.data,
                              :cotacao         => venda.cotacao,
                              :fatura          => 0,
                              :vendedor_id     => venda.vendedor_id,
                              :vendedor_nome   => params[:vendedor_nome],
                              :clase_produto   => 0,
                              :documento_numero_01 => '000',
                              :documento_numero_02 => '000',
                              :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                              :moeda           => 1,
                              :cota            => ct,
                              :titular         => params[:titular],
                              :valor_dolar     => vuel_us,
                              :valor_guarani   => vuel_gs.to_f,
                              :valor_real      => vuel_rs,
                              :valor_peso      => vuel_ps,
                              :cred_deb        => 1,
                              :usuario_id      => params[:usuario_id],
                                :fact_ad_01      => params[:fact_ad_01],
                                :fact_ad_02      => params[:fact_ad_02],
                                :fact_ad      => params[:fact_ad],
                                :obs          => params[:obs]
                              )
    end

    #forma de pagos a credito 
    else
      if params[:cota_fixa] == '1'
        parc_us = (val_us.to_f)
        parc_gs = (val_gs.to_f)
        parc_rs = (val_rs.to_f)
        parc_ps = (val_ps.to_f)
      else
        parc_us = (val_us.to_f / params[:cota].to_i)
        parc_gs = (val_gs.to_f / params[:cota].to_i)
        parc_rs = (val_rs.to_f / params[:cota].to_i)
        parc_ps = (val_ps.to_f / params[:cota].to_i)
      end
      venc = 0
      cota = 1
      params[:cota].to_i.times do
        VendasFinanca.create( :venda_id        => params[:id],
                                :forma_pago_id   => params[:forma_pg],
                                :cartao_bandeira_id => params[:busca]["cartao_bandeiras"],
                                :controle_caixa => params[:controle_caixa],
                                :tipo            => forma_de_pagamento.tipo,
                                :cheque_status   => params[:cheque_status],
                                :diferido        => params[:diferido],
                                :data            => venda.data,
                                :vencimento      =>  params[:vencimento].to_date.months_since(venc.to_i),
                                :cotacao         => venda.cotacao,
                                :fatura          => 0,
                                :vendedor_id     => venda.vendedor_id,
                                :clase_produto   => 0,
                                :documento_numero_01 => '000',
                                :documento_numero_02 => '000',
                                :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                                :moeda           => params[:moeda],
                                :nr_comprovante  => params[:nr_comprovante],
                                :cota            => cota,
                                :titular         => params[:titular],
                                :valor_dolar     => parc_us.to_f,
                                :valor_guarani   => parc_gs.to_f,
                                :valor_real      => parc_rs.to_f,
                                :valor_peso      => parc_ps.to_f,
                                :desconto        => params[:desc_gs].to_f,
                                :usuario_id      => params[:usuario_id],
                                :fact_ad_01      => params[:fact_ad_01],
                                :fact_ad_02      => params[:fact_ad_02],
                                :fact_ad      => params[:fact_ad],
                                :tot_cotas => params[:tot_cotas],
                                :obs          => params[:obs] )
        venc += 1
        cota += 1
      end
    end
  end

  def self.filtro_vendas(params)
    unidade = "AND V.UNIDADE_ID = #{params[:unidade]}"
    caixa   = "AND V.CONTROLE_CAIXA = #{params[:caixa]}" unless params[:caixa].blank?
    tipo_venda = "AND V.TIPO_VENDA = #{params[:tipo_venda]}" unless params[:tipo_venda].blank?
    if params[:tipo] == "CODIGO"
      tipo = "V.ID"
      cond =  " AND V.ID = #{params[:busca]} " unless params[:busca].blank?
    elsif params[:tipo] == "DOC"
      tipo = "V.DOCUMENTO_NUMERO "
      cond =  " AND #{tipo} LIKE ? ","%#{params[:busca]}%" unless params[:busca].blank?
    elsif params[:tipo] == "CLIENTE"
      tipo = "V.PERSONA_NOME"
      cond =  " AND #{tipo} LIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    elsif params[:tipo] == "COMANDA"
      tipo = "CT.NOME"
      cond =  " AND #{tipo} = '#{params[:busca]}' " unless params[:busca].blank?

    end
    if params[:finalidade] == "VENTA"
      finalidade =  "AND V.FINALIDADE = 0"
    else
      finalidade =  "AND V.FINALIDADE = 1"
    end


    if params[:processo] == "venda-finalizada"
      fin = "AND (SELECT SUM(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID) > 0"
    end
    sql = "SELECT V.ID,
                   V.USUARIO_CREATED,
                   V.DATA,
                   V.TIPO_VENDA,
                   V.MOEDA,
                   V.PERSONA_NOME,
                   V.TIPO,
                   VD.NOME AS VENDEDOR_NOME,
                   U.USUARIO_NOME,
                   V.CONTROLE_CAIXA,
                   V.FINALIDADE,
                   V.OP,
                   V.OBS,
                   CT.NOME AS CARTAO_NOME,
                   V.DOCUMENTO_NUMERO_01 || '-' || V.DOCUMENTO_NUMERO_02 || '-' || V.DOCUMENTO_NUMERO AS DOC, 
                   (SELECT SUM(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID) AS FIN,
                   (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS QTD,
                   (SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_GS,
                   (SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_US,
                   (SELECT SUM(VP.TOTAL_REAL) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_RS
            FROM VENDAS V
            LEFT JOIN PERSONAS VD
            ON V.VENDEDOR_ID = VD.ID

            LEFT JOIN CARTAOS CT
            ON CT.ID = V.CARTAO_ID
            
            LEFT JOIN USUARIOS U
            ON V.USUARIO_CREATED = U.ID

            WHERE V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{unidade} #{cond} #{caixa} #{tipo_venda}  #{finalidade} #{fin}

            ORDER BY 3 desc, 1 desc
                   
               "
    Venda.paginate_by_sql(sql, page: params[:page], :per_page => 25)
  end

  def finds
    vendedor = Persona.find_by_id(self.vendedor_id);
    self.vendedor_nome = vendedor.nome.to_s unless  self.vendedor_id.blank?

    per = Persona.find_by_id(self.persona_id);
    self.persona_nome = per.nome unless  self.persona_id.blank?
    md =  Moeda.last(:select => 'dolar_compra,rs_us_compra,real_compra,ps_gs_compra')
    self.cotacao = md.dolar_compra
    self.cotacao_real = md.real_compra
    self.cotacao_rs_us = md.rs_us_compra
    self.cotacao_gs_ps = md.ps_gs_compra

    if self.moeda.to_i == 0
      self.desconto_gs = self.desconto_us.to_f * self.cotacao.to_f
    else
      self.desconto_us = self.desconto_gs.to_f / self.cotacao.to_f
      self.desconto_rs = self.desconto_gs.to_f / self.cotacao_real.to_f
    end
  end

end

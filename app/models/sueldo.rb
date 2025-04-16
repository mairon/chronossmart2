class Sueldo < ActiveRecord::Base

  has_many :sueldos_detalhes, :dependent => :destroy
  has_many :sueldo_pagos, :dependent => :destroy

  has_many :compras
  belongs_to :persona
  before_save :finds
  after_save :sueldo
  #validates_uniqueness_of :persona_id, scope: [:data_inicio], message: "Já habilitado neste Periodo"


  def self.filtro(params)
    month = "AND date_part('month', S.DATA_INICIO) = '#{params[:date]['month']}'" unless params[:date]['month'].blank?
    year = "AND date_part('YEAR', S.DATA_INICIO) = '#{params[:date]['year']}'" unless params[:date]['year'].blank?

    tipo = ""
    cond =  "AND PERSONA_NOME ILIKE '%#{params[:busca]}%'"  unless params[:busca].blank?
    sql = "SELECT S.ID,
                  S.DATA_INICIO,
                  S.TIPO_LIQUIDACAO,
                  P.NOME AS PERSONA_NOME,
                  S.DIAS,
                  (SELECT COUNT(SP.ID) FROM SUELDO_PAGOS SP WHERE SP.SUELDO_ID = S.ID) AS PAGO
            FROM SUELDOS S
            INNER JOIN PERSONAS P
            ON P.ID = S.PERSONA_ID
            WHERE S.UNIDADE_ID = #{params[:unidade]} AND S.TIPO_LIQUIDACAO = #{params[:tipo]} #{month} #{year} #{cond}"
    Sueldo.paginate_by_sql(sql, page: params[:page], :per_page => 30)
  end

  def finds
    per = Persona.find_by_id(self.persona_id);
    self.persona_nome        = per.nome.to_s;
    self.salario             = per.salario.to_f;
    self.salario_minimo      = per.salario_minimo.to_f;
    self.comissao            = per.comissao.to_f;
    self.ci                  = per.ci.to_f;
    self.ips                 = per.ips.to_f;

  end

  def sueldo
      if self.tipo_liquidacao == 0
        tipo_li = 'SUELDO'
        escala = PersonaEscala.where("tipo = 1 and date_part('month', DATA) = '#{self.data_inicio.strftime("%m")}' and  date_part('year', DATA) = '#{ self.data_inicio.strftime("%Y")}' and persona_id = #{self.persona_id}").count(:id)
        solit  = Solicitude.joins(:usuario).where("desc_folha = true and date_part('month', solicitudes.data ) = '#{self.data_inicio.strftime("%m")}' and date_part('year', solicitudes.data ) = '#{self.data_inicio.strftime("%Y")}' and usuarios.persona_id = #{self.persona_id} ").sum(:hrs_desc)


        puts "horas #{solit}"
        if solit.to_i > 0
          st = solit.to_i * ((self.salario.to_f / 30) / 8)
        else
          st = 0
        end
        puts "===========================================#{st.to_i}"
        self.dias = (self.dias - (escala.to_i + (solit.to_f / 8) ) )
        salario_dia = (self.salario.to_f / 30)
        puts "salario base #{self.salario.to_f}"
        puts "salario dia #{salario_dia}"
        salario_propor = ((salario_dia.to_f * self.dias.to_i))

      elsif self.tipo_liquidacao == 1
        tipo_li = 'VACACIONES'


        escala = PersonaEscala.where("tipo = 1 and DATA BETWEEN '#{self.inicio_ponto}' and '#{self.final_ponto}' and persona_id = #{self.persona_id}").count(:id)

        self.dias = ( escala.to_i)
        salario_dia = (self.salario.to_f / 30)
        salario_propor = (salario_dia.to_f * self.dias.to_i)

      elsif self.tipo_liquidacao == 2
        tipo_li = 'AGUINALDO'

        salario_dia = SueldosDetalhe.where("tipo IN ('SUELDO', 'VACACIONES') and persona_id = #{self.persona_id} AND date_part('YEAR', DATA) = '#{self.data_inicio.to_date.strftime('%Y')}'").sum("credito_gs")
        salario_propor = (salario_dia.to_f / 12)
      end

      calc_ip = (salario_propor.to_f * 0.09)

      if self.moeda == 0
        SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                               :data             => self.data_inicio,
                               :vencimento       => self.data_inicio,
                               :tipo             => "#{tipo_li}",
                               :documento_numero_01 =>'000',
                               :documento_numero_02 =>'000',
                               :documento_numero    =>'700' + self.id.to_s,
                               :cota             => 0,
                               :estado           => 1,
                               :moeda            => self.moeda,
                               :descricao        => "PAGO POR #{self.dias} DIAS #{tipo_li} REFERENTE AL MES DE "+"#{self.data_inicio}".to_date.strftime("%m/%Y"),
                               :persona_id       => self.persona_id,
                               :persona_nome     => self.persona_nome,
                               :credito_us       =>  self.salario.to_f,
                               :credito_gs       =>  0,
                               :credito_rs       =>  0,
                               :debito_us        =>  0,
                               :debito_gs        =>  0,
                               :debito_rs        =>  0)

      elsif self.moeda == 1
        SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                               :data             => self.data_inicio,
                               :vencimento       => self.data_inicio,
                               :dias             => self.dias,
                               :tipo             => "#{tipo_li}",
                               :documento_numero_01 =>'000',
                               :documento_numero_02 =>'000',
                               :documento_numero    =>'700' + self.id.to_s,
                               :cota             => 0,
                               :estado           => 1,
                               :moeda            => self.moeda,
                               :descricao        => "PAGO POR #{tipo_li} REFERENTE AL MES DE "+"#{self.data_inicio}".to_date.strftime("%m/%Y"),
                               :persona_id       => self.persona_id,
                               :persona_nome     => self.persona_nome,
                               :credito_us       =>  0,
                               :credito_gs       =>  salario_propor.to_f,
                               :credito_rs       =>  0,
                               :debito_us        =>  0,
                               :debito_gs        =>  0,
                               :debito_rs        =>  0)
        #ips
        if self.tipo_liquidacao.to_i != 2
          if self.persona.ips.to_f > 0
            SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                                   :data             => self.data_inicio,
                                   :vencimento       => self.data_inicio,
                                   :dias             => self.dias,
                                   :tipo             => "IPS",
                                   :documento_numero_01 =>'000',
                                   :documento_numero_02 =>'000',
                                   :documento_numero    =>'700' + self.id.to_s,
                                   :cota             => 0,
                                   :estado           => 1,
                                   :moeda            => self.moeda,
                                   :descricao        => "IPS REFERENTE AL MES DE "+"#{self.data_inicio}".to_date.strftime("%m/%Y"),
                                   :persona_id       => self.persona_id,
                                   :persona_nome     => self.persona_nome,
                                   :credito_us       =>  0,
                                   :credito_gs       =>  0,
                                   :credito_rs       =>  0,
                                   :debito_us        =>  0,
                                   :debito_gs        =>  calc_ip.to_f,
                                   :debito_rs        =>  0)
          end
        end

      else
        SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                               :data             => self.data_inicio,
                               :vencimento       => self.data_inicio,
                               :tipo             => "#{tipo_li}",
                               :documento_numero_01 =>'000',
                               :documento_numero_02 =>'000',
                               :documento_numero    =>'700' + self.id.to_s,
                               :cota             => 0,
                               :estado           => 1,
                               :moeda            => self.moeda,
                               :descricao        => "#{tipo_li} REFERENTE AL MES DE "+"#{self.data_inicio}".to_date.strftime("%m/%Y"),
                               :persona_id       => self.persona_id,
                               :persona_nome     => self.persona_nome,
                               :credito_us       =>  0,
                               :credito_gs       =>  0,
                               :credito_rs       =>  salario_propor.to_f,
                               :debito_us        =>  0,
                               :debito_gs        =>  0,
                               :debito_rs        =>  0)
      end

    end
end

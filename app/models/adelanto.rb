class Adelanto < ActiveRecord::Base
		#audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
		has_many :adelanto_cotas,:order => 'cota', :dependent => :destroy
		belongs_to :persona
		belongs_to :centro_custo
		validates_presence_of :cotacao,:valor_dolar,:valor_guarani,:status
		before_save :finds, :gera_cod

		def gera_cod
			if self.documento_numero == ''
				if self.tipo == 2
				 self.documento_numero = (Adelanto.where(tipo: 2).maximum(:id) + 1).to_s.rjust(6,'0')
				 self.documento_numero_01 = '009'
				 self.documento_numero_02 = '009'
				else
					self.documento_numero = '999'<< self.persona_id.to_s
					self.documento_numero_01 = '009'
					self.documento_numero_02 = '009'
				end
			end
		end

		def finds
			persona = Persona.find_by_id(self.persona_id);
			self.persona_nome = persona.nome.to_s unless self.persona_id.blank?

			vend = Persona.find_by_id(self.vendedor_id);
			self.vendedor_nome = vend.nome.to_s unless self.vendedor_id.blank?

			conta = Conta.find_by_id(self.conta_id);
			self.conta_nome = conta.nome.to_s;

			per = Persona.find_by_id(self.banco_id)
			self.banco   = per.nome.to_s unless self.banco_id.blank?
		end

		def self.filtro_busca(params)
				unidade = " A.UNIDADE_ID = #{params[:unidade]}"
				unless params[:inicio].blank?
						cond =  "#{unidade} and A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
				else
						cond =  "#{unidade}"
				end

				if params[:tipo] == "CODIGO"
						tipo = "A.ID"
						cond =  "#{unidade} AND #{tipo} = '#{params[:busca]}' " unless params[:busca].blank?
				elsif params[:tipo] == "NOMBRE"
						tipo = "A.PERSONA_NOME"
						cond =  "#{unidade} AND  #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?

				else
						tipo = "A.DOCUMENTO_NUMERO"
						cond =  "#{unidade} AND #{tipo} ILIKE '%#{params[:busca]}%' " unless params[:busca].blank?

				end
				sql = "SELECT A.ID,
											A.DATA,
											A.PERSONA_NOME,
											A.CONTA_NOME,
											A.MOEDA,
											A.VALOR_DOLAR,
											A.VALOR_GUARANI,
											A.VALOR_REAL,
											A.CENTRO_CUSTO_ID
								FROM ADELANTOS A
								WHERE A.TIPO_ADELANTO = #{params[:tipo_adelanto]} and #{cond}
								ORDER BY DATA DESC, ID DESC"

				self.paginate_by_sql(sql, :page => params[:page], :per_page => 25)
		end

	def self.gerador_cotas(params)
		cota = 1
		venc = 0
		cp = Adelanto.find_by_id(params[:id])
		if cp.moeda.to_i == 0
			valor_us = params[:valor_us].to_f / params[:cotas].to_i
			valor_gs = (params[:valor_us].to_f / params[:cotas].to_i) * cp.cotacao.to_f
		elsif cp.moeda.to_i == 2
			valor_rs = params[:valor_rs].to_f / params[:cotas].to_i
			valor_gs = (params[:valor_rs].to_f / params[:cotas].to_i) * cp.cotacao_real.to_f
			valor_us = (params[:valor_rs].to_f / params[:cotas].to_i) / cp.cotacao.to_f
		else
			valor_gs = params[:valor_gs].to_f / params[:cotas].to_i
			valor_us = (params[:valor_gs].to_f / params[:cotas].to_i) / cp.cotacao.to_f
		end
		params[:cotas].to_i.times do
			AdelantoCota.create( :adelanto_id => params[:id],
									:tipo                => cp.tipo,
									:status              => cp.status,
									:data                => cp.data,
									:concepto           => cp.concepto,
									:documento_numero    => cp.documento_numero,
									:persona_id          => cp.persona_id,
									:persona_nome        => cp.persona_nome,
									:moeda               => cp.moeda,
									:cota                => cota,
									:unidade_id          => cp.unidade_id,
									:valor_gs            => valor_gs.to_f,
									:valor_us            => valor_us.to_f,
									:valor_rs            => valor_rs.to_f,
									:vencimento          => params[:venci].to_date.months_since(venc.to_i) )

			cota += 1
			venc += 1
		end
	end
end

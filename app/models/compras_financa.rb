class ComprasFinanca < ActiveRecord::Base
  belongs_to :compra
  belongs_to :conta
  belongs_to :persona
  belongs_to :forma_pago
  validates_presence_of :valor_dolar, :valor_guarani
  #validates_uniqueness_of :documento_numero  , :scope=>[:persona_id, :documento_numero_01, :documento_numero_02, :persona_id, :cota], :message => " ja cadastrado."
  after_save :liquida_prov_gasto, :finds
  after_destroy :liquida_prov_gasto

  after_create :trigger_viatico_cliente
  after_destroy :trigger_viatico_cliente_destroy

  def trigger_viatico_cliente

      extrato = Cliente.where(persona_id: compra.funcionario_id, documento_numero_01: 'V00', documento_numero: self.fact_an )
      if self.moeda == 0
         if extrato.sum('divida_dolar - cobro_dolar') == 0 
            extrato.update_all(liquidacao: 1)
         end

      elsif self.moeda == 1
         if extrato.sum('divida_guarani - cobro_guarani').to_f == 0 
            extrato.update_all(liquidacao: 1)
         end

      elsif self.moeda == 2
         if extrato.sum('divida_real - cobro_real').to_f == 0 
            extrato.update_all(liquidacao: 1)
         end
      end
  end

  def trigger_viatico_cliente_destroy
    extrato = Cliente.where(persona_id: self.persona_id, documento_numero_01: 'V00', documento_numero: self.documento_numero )
    extrato.update_all(liquidacao: 0)
  end    


    def finds
        if compra.moeda == 0
          self.valor_guarani = self.valor_dolar.to_f * compra.cotacao.to_f
          self.valor_real = self.valor_dolar.to_f / compra.cotacao_rs_us.to_f

        elsif compra.moeda == 1
          self.valor_dolar = self.valor_guarani.to_f / compra.cotacao.to_f
          #self.valor_real = self.valor_guarani.to_f / compra.cotacao_real.to_f
        elsif compra.moeda == 2
          self.valor_guarani = self.valor_real.to_f * compra.cotacao_real.to_f
          self.valor_dolar = self.valor_real.to_f / compra.cotacao_rs_us.to_f

        elsif compra.moeda == 4
          self.valor_guarani = self.valor_euro.to_f * compra.cotacao_eu_gs.to_f
          self.valor_dolar = self.valor_euro.to_f * compra.cotacao_eu_us.to_f
        end

        conta          = Conta.find_by_id(self.conta_id);
        self.conta_nome = conta.nome.to_s  unless self.conta_id.blank?;

        if compra.tipo_compra == 1
            if compra.descricao == ''
                self.descricao = "GASTO #{compra.rubro_nome} Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"
            end
        elsif compra.tipo_compra == 0
                self.descricao = "COMPRA DE MERCADORIA Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"

        elsif compra.tipo_compra == 2
                self.descricao = "COMPRA DE MERCADORIA IMPORTACION Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"
        elsif compra.tipo_compra == 3
                self.descricao = "COMPRA DE BIENES Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"
        end
    end

    def liquida_prov_gasto 
      if compra.prov_gasto_id.to_i > 0 
        titulo = Proveedore.where( persona_id: compra.persona_id, documento_numero: compra.documento_numero, documento_numero_01: compra.documento_numero_01, 
                documento_numero_02: compra.documento_numero_02, cota: compra.cota )
        if compra.moeda.to_i == 0
          div_us = Proveedore.where( persona_id: compra.persona_id, documento_numero: compra.documento_numero, documento_numero_01: compra.documento_numero_01, 
                documento_numero_02: compra.documento_numero_02, cota: compra.cota ).sum(:divida_dolar)
          pago_us = Proveedore.where( persona_id: compra.persona_id, documento_numero: compra.documento_numero, documento_numero_01: compra.documento_numero_01, 
                documento_numero_02: compra.documento_numero_02, cota: compra.cota ).sum(:pago_dolar)
          if div_us.to_f == pago_us.to_f
            titulo.each do |t|
              t.update_attribute :liquidacao, 1
            end
            
          else
            titulo.each do |t|
              t.update_attribute :liquidacao, 0
            end
          end
        elsif compra.moeda.to_i == 1
          div_gs = Proveedore.where( persona_id: compra.persona_id, documento_numero: compra.documento_numero, documento_numero_01: compra.documento_numero_01, 
                documento_numero_02: compra.documento_numero_02, cota: compra.cota ).sum(:divida_guarani)
          pago_gs = Proveedore.where( persona_id: compra.persona_id, documento_numero: compra.documento_numero, documento_numero_01: compra.documento_numero_01, 
                documento_numero_02: compra.documento_numero_02, cota: compra.cota ).sum(:pago_guarani)
          if div_gs.to_f == pago_gs.to_f
            titulo.each do |t|
              t.update_attribute :liquidacao, 1
            end
            
          else
            titulo.each do |t|
              t.update_attribute :liquidacao, 0
            end
          end

        elsif compra.moeda.to_i == 2
          div_rs = Proveedore.where( persona_id: compra.persona_id, documento_numero: compra.documento_numero, documento_numero_01: compra.documento_numero_01, 
                documento_numero_02: compra.documento_numero_02, cota: compra.cota ).sum(:divida_real)
          pago_rs = Proveedore.where( persona_id: compra.persona_id, documento_numero: compra.documento_numero, documento_numero_01: compra.documento_numero_01, 
                documento_numero_02: compra.documento_numero_02, cota: compra.cota ).sum(:pago_real)
          if div_rs.to_f == pago_rs.to_f
            titulo.each do |t|
              t.update_attribute :liquidacao, 1
            end
            
          else
            titulo.each do |t|
              t.update_attribute :liquidacao, 0
            end
          end

        end
      end
    end

end

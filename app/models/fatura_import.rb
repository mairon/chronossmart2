class FaturaImport < ActiveRecord::Base
  has_many :fatura_import_produtos
  before_save :importa_dados_xml
  after_save :importa_dados_xml_produtos

  def importa_dados_xml

    doc = Nokogiri::XML(self.data_xml.to_s)

    doc.css('gTimb').each do |node|
      children = node.children
        self.dnumtim = children.css('dNumTim').inner_text
        self.dest = children.css('dEst').inner_text
        self.dpunexp = children.css('dPunExp').inner_text
        self.dnumdoc = children.css('dNumDoc').inner_text
    end

    doc.css('gDatGralOpe').each do |node|
      children = node.children
      self.dfeemide = Date.parse(children.css('dFeEmiDE').inner_text.to_s)
      self.cmoneope = children.css('cMoneOpe').inner_text
    end

    doc.css('gEmis').each do |node|
      children = node.children
      self.drucem = children.css('dRucEm').inner_text
      self.ddvemi = children.css('dDVEmi').inner_text
      self.dnomemi = children.css('dNomEmi').inner_text

    end

    doc.css('gCamCond').each do |node|
      children = node.children
      self.icondope = children.css('iCondOpe').inner_text
      self.ddcondope = children.css('dDCondOpe').inner_text
      self.dplazocre = children.css('dPlazoCre').inner_text
    end

    doc.css('gTotSub').each do |node|
      children = node.children
      self.dtotgralope = children.css('dTotGralOpe').inner_text.to_f
    end
  end


  def importa_dados_xml_produtos

    doc = Nokogiri::XML(self.data_xml.to_s)

    doc.css('gCamItem').each do |node|
      children = node.children
      fip = FaturaImportProduto.create(fatura_import_id: self.id, 
        dcodint: children.css('dCodInt').inner_text,
        ddesproser:  children.css('dDesProSer').inner_text.to_s.gsub("'", ''),
        ddesunimed:  children.css('dDesUniMed').inner_text,
        dcantproser:  children.css('dCantProSer').inner_text.to_f,
        ddescitem:  children.css('dDescItem').inner_text.to_f,
        dtotopeitem:  children.css('dTotOpeItem').inner_text.to_f

        )


        Produto.create(
          fabricante_cod: fip.dcodint,
          nome: "#{fip.ddesproser} TM #{fip.tamanho}",
          taxa: 10,
          doc: self.dnumdoc,
          tipo_produto: 0,
          barra: '',
          custo_base_gs: fip.dtotopeitem.to_f,
          clase_id: self.clase_id,
          sub_grupo_id: self.colecao_id

        )
    end
  end

end

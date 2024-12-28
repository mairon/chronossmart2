
pdf.text "Libro Compra", :size => 12, :style => :bold,:align => :center

pdf.move_down(10)
 

head = [['......','.............','...........','..............................','....................................','..................','','','','','','','']]

compra   = @compra.map do |item|
            if item.compra.tipo_compra == 0
               [
                     
                        item.data.strftime("%d"),
                        item.id,
                        number_to_currency(item.cotacao, :format=>' %n ', :precision => 0),
                        item.documento_numero_01 + '-' + item.documento_numero_02  + '-' + item.documento_numero,
                        item.documento_nome,
                        item.data.strftime("%d/%m/%Y"),
                        item.persona_nome,
                        number_to_currency(item.exentas_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.gravadas_05_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.imposto_05_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.gravadas_10_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.imposto_10_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.total_guarani, :format=>' %n ', :precision => 0),
                     
               ]
            end
end                                

  compra << [{:text => 'Total', :colspan => 2}, '37.0', '1002.5', '3833']



tipo_gasto = 0
gasto     = @compra.map do |item|
tipo_gasto = tipo_gasto.to_i + 1
if item.compra.tipo_compra == 1 and  tipo_gasto > 0
  
               [

                        item.data.strftime("%d"),
                        item.id,
                        number_to_currency(item.cotacao, :format=>' %n ', :precision => 0),
                        item.documento_numero_01 + '-' + item.documento_numero_02  + '-' + item.documento_numero,
                        item.documento_nome,
                        'sdds',
                        item.persona_nome,
                        number_to_currency(item.exentas_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.gravadas_05_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.imposto_05_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.gravadas_10_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.imposto_10_guarani, :format=>' %n ', :precision => 0),
                        number_to_currency(item.total_guarani, :format=>' %n ', :precision => 0),

               ]

else
['......','.............','...........','..............................','....................................','..................','','','','','','','']
end
end




pdf.table head,
    :font => 'Times-Roman',
    :font_size  => 7,
    :border_style => :grid,
    :horizontal_padding => 5,
    :vertical_padding   => 1,
    :border_width       => 1,
    :position => -10,
    :header_font_size => 7,
    :header_color  => "C0C0C0",
    :headers => ["Dia","Numero","Cotiz","Numero","Documento","Fecha","                                       Proveedor                                   ","     Exentas     ","Gravadas 05%","Impuestos 05%","Gravadas 10%","Impuestos 10%","     Total      "],
    :align   => { 0 => :center,1 => :center,2 => :center,3 => :center,4 => :center,5 => :center,6 => :center,5 => :center,6 => :center,7 => :center,8 => :center,9 => :center,10 => :center,11 => :center,12 => :center}

pdf.table compra,
    :font => 'Times-Roman',
    :font_size  => 7,
    :border_style => :grid,
    :horizontal_padding => 5,
    :vertical_padding   => 1,
    :border_width       => 1,
    :position => -10,
    :header_font_size => 7,
    :headers => ['......','.............','...........','..............................','...................................','..................','COMPRAS MERCADERIAS INTERNAS                          ','.......................','........................','.........................','........................','.........................','....................'],
    :align   => { 0 => :center,1 => :center,2 => :center,3 => :center,4 => :left,5 => :center,6 => :center,5 => :center,6 => :left,7 => :right,8 => :right,9 => :right,10 => :right,11 => :right,12 => :right}


pdf.table gasto,
    :font => 'Times-Roman',
    :font_size  => 7,
    :border_style => :grid,
    :horizontal_padding => 5,
    :vertical_padding   => 1,
    :border_width       => 1,
    :position => -10,
    :header_font_size => 7,
    :headers => ['......','.............','...........','..............................','...................................','..................','COMPRAS MERCADERIAS INTERNAS                          ','.......................','........................','.........................','........................','.........................','....................'],
    :align   => { 0 => :center,1 => :center,2 => :center,3 => :center,4 => :left,5 => :center,6 => :center,5 => :center,6 => :left,7 => :right,8 => :right,9 => :right,10 => :right,11 => :right,12 => :right}


pdf.move_down(10)


  pdf.number_pages "<page> de <total>", [pdf.bounds.right - 50, 0]

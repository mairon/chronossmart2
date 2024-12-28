
pdf.text "MercoSys Enterprise", :size => 12, :style => :bold,:align => :center

pdf.text ".                                                                                                                                  Relatorio de Stock", :size => 10, :style => :bold

pdf.move_down(10)

relatorio =  @stocks.map do |item|
                     entradas = Stock.sum( :entrada,:conditions => ['produto_id = ?',item.produto_id] )
                     saidas   = Stock.sum( :saida  ,:conditions => ['produto_id = ?',item.produto_id] )
                     stock    = entradas - saidas
                       [
                        item.data.strftime("%d/%m/%Y"),
                        item.codigo,
                        item.status,
                        item.produto_nome,
                        format( "%.3f",item.entrada.to_f ),
                        format( "%.3f",item.saida.to_f ),
                        format( "%.3f",stock.to_f ),

                       ]
             end


pdf.table extractos,
    :font => 'Times-Roman',
    :font_size  => 7,
    :border_style => :underline_header,
    :horizontal_padding => 5,
    :vertical_padding   => 1,
    :border_width       => 1,
    :position => -10,
    :header_font_size => 9,
    :headers => ["Fecha","Codigo","Status","Producto", "Entrada", "Salida", "Saldo"],
    :align => { 0 => :center,1 => :center,2 => :center, 3 => :left, 4 => :right, 5 => :right, 6 => :right}

pdf.move_down(10)

pdf.text "____________________________________________________________________________________", :size => 8,:align => :left
pdf.text "Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")}", :size => 8,:align => :left



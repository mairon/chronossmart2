pdf.text "MercoSys Enterprise", :size => 12, :style => :bold,:align => :center

pdf.text ".                                                                                                                                  Relatorio Financas", :size => 10, :style => :bold


pdf.move_down(10)



#FLETE-------------------------------------------------------------------------------------------------

entrada = 0
saida   = 0
saldo   = 0

@financas.map do |item|
entrada = entrada.to_f + item.entrada_guarani.to_f
saida   = saida.to_f   + item.saida_guarani.to_f
saldo   = entrada - saida
end


extractos =  @financas.map do |item|
 [
  item.data.strftime("%d/%m/%Y"),
  item.conta_id,
  item.conta_nome,
  number_to_currency(item.entrada_guarani, :format=>' %n ', :precision => 0),
  number_to_currency(item.saida_guarani, :format=>' %n ', :precision => 0),
 ]  
end

pdf.table extractos,
    :font => 'Times-Roman',
    :font_size  => 7,
    :border_style => :underline_header,
    :horizontal_padding => 30,
    :vertical_padding   => 1,
    :border_width       => 1,
    :position => -10,
    :header_font_size => 9,
    :headers => ["Fecha","Cod", "Conta", "Entrada", "Salida"],
    :align => { 0 => :center,1 => :center, 2 => :left, 3 => :right, 4 => :right}

pdf.move_down(5)
pdf.text "Anterior : #{number_to_currency(@financas_aterior,    :format=>' %n ', :precision => 0)}                                                                                                                                   #{number_to_currency(entrada,    :format=>' %n ', :precision => 0)}                            #{number_to_currency(saida,    :format=>' %n ', :precision => 0)}           #{number_to_currency(saldo,    :format=>' %n ', :precision => 0)}", :size => 7, :style => :bold


pdf.text "____________________________________________________________________________________", :size => 8,:align => :left
pdf.text "Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")}", :size => 8,:align => :left



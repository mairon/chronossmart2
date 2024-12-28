pdf.text "MercoSys Enterprise", :size => 12, :style => :bold,:align => :center

pdf.text ".                                                                                                                                  Relatorio Contas Receber", :size => 10, :style => :bold

pdf.move_down(10)

pdf.text "Fecha  Codigo   Documento                                          N.                   Cuota           Vencimento                  Deuda             Pago            Saldo", :size => 7, :style => :bold

pdf.move_down(10)

 quebra    = "" 
 subdivida = 0 
 subpago   = 0
 totdivida = 0
 subsaldo  = 0
 totpago   = 0
 totsaldo  = 0
 extractos =  @proveedores.map do |item|

              if quebra != item.persona_nome

                 if quebra != ""

                    subsaldo = subdivida - subpago
                    pdf.text ".                                                                                                                                #{number_to_currency(subdivida, :format=>' %n ', :separator => ",")}         #{number_to_currency(subpago, :format=>' %n ', :separator => ",")}             #{number_to_currency(subsaldo, :format=>' %n ', :separator => ",")}", :style => :bold, :size => 10
                    pdf.move_down(10)

                    subdivida = 0
                    subpago   = 0
                    subsaldo  = 0

                 end

                 quebra = item.persona_nome
                         
                 pdf.text "                          #{item.persona_nome}", :size => 8, :style => :bold

              end


              pdf.text "#{item.data.strftime("%d/%m/%Y")}  #{item.persona_id}   #{truncate( item.documento_nome, :length => 18, :separator => '')}                  #{item.documento_numero_01}-#{item.documento_numero_02}-#{item.documento_numero}              #{item.cota}              #{item.vencimento.strftime("%d/%m/%Y")}                     #{number_to_currency(item.divida_guarani, :format=>' %n ', :precision => 0)}                      #{number_to_currency(item.pago_guarani, :format=>' %n ', :precision => 0)}", :size => 7


              subdivida = subdivida + item.divida_guarani
              subpago  = subpago  + item.pago_guarani

              totdivida = totdivida + item.divida_guarani
              totpago  = totpago  + item.pago_guarani

 end
              subsaldo = subdivida - subpago
              pdf.text ".                                                                                                                                                                          #{number_to_currency(subdivida, :format=>' %n ', :precision => 0)}           #{number_to_currency(subpago, :format=>' %n ', :precision => 0)}           #{number_to_currency(subsaldo, :format=>' %n ', :precision => 0)}", :style => :bold, :size => 7
 
 pdf.move_down(10)

              totsaldo = totdivida - totpago
              pdf.text ".                                                                                                                                                           Total :     #{number_to_currency(totdivida, :format=>' %n ', :precision => 0 )}           #{number_to_currency(totpago, :format=>' %n ', :precision => 0)}           #{number_to_currency(totsaldo, :format=>' %n ', :precision => 0)}", :style => :bold, :size => 7
 

 pdf.move_down(10)

 pdf.text "____________________________________________________________________________________", :size => 8,:align => :left
 pdf.text "Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")}", :size => 8,:align => :left



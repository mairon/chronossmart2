class GeradorsController < ApplicationController

  before_filter :authenticate
  def gerador_arquivo
    render :layout => false
  end
  def result_gerador
    index = Rails.root + "app/views/relatorios/#{params[:arq]}.html.erb"
    File.new(index, 'wb')

    result = Rails.root + "app/views/relatorios/resultado_#{params[:arq]}.html.erb"
    File.new(result, 'wb')

    File.open(index, 'wb') do |f|
      f.write "   <h1 id='header'></h1>
   <div class='group'>
      <h2>
         <%= form_tag #{params[:arq]}_relatorios_path, :method => 'get' do%>
            <table>

               <tr>
                  <td align='right'> Fecha : </td>
                  <td>
                     <input name='inicio' id='inicio'  size='10'  onkeyup='Formatadata(this,event)' type='text' />
                     Hasta
                     <input name='final'  id='final'   size='10' onkeyup='Formatadata(this,event)' type='text'/>
                  </td>
               </tr>

               <tr > 
                  <td></td>
                  <td>
                     <input  id      = 'button'
                             class   = 'button_info'
                             type    = 'submit'
                             value   = 'Informe'
                             onclick = 'Tipo('0')'/>

                     <input type     = 'submit'
                            id       = 'button'
                            class    = 'button_info'
                            value    = 'Excel'
                            onclick  = 'Tipo('1')'/>
                  </td>
               </tr>

               <input type  = 'hidden'
                      name  = 'tipo'
                      id    = 'tipo'
                      size  = '5'
                      value = '0'/>

            </table>
         <% end %>
      </h2>
   </div>
</body>


"
      f.close
    end
  end

end

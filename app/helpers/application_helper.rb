module ApplicationHelper

  def flash_class(level)
      case level
          when :notice then "alert alert-info"  
          when :success then "alert alert-success"
          when :error then "alert alert-error"
          when :alert then "alert alert-error"
       end
  end

  def links(url_menu,url_edit,url_delete,url_visualiza,html_options={})
      menu = UsuarioPerfil.find_by_codigo(url_menu)
      options_edit = { :size  => 15,
                          :class => "money_gs",
                          :precision => 0,
                          :dir   => "rtl",
                          :step  => "any" }.merge(html_options)
      %Q{ <td #{html_options}> #{link_to 'Editar', url_edit if menu.u == true} </td>
          <td #{html_options}> #{ link_to t('DELETE'), url_delete, :confirm => t('CONFIRMATION_MESSAGE'), :method => :delete if menu.d == true}</td>
          <td #{html_options}>#{ link_to 'CV', url_visualiza if menu.r == true }}.html_safe
  end

  def field_us(text,form,field,html_options={})

      options = { :size  => 15,
                  :class => "money_us",
                  :dir   => "rtl" ,
                  :step  => ".01"}.merge(html_options)

      %Q{ <td align="right">#{text}</td>
          <td>#{form.telephone_field field,options}</td> }.html_safe
  end

  def field_us_label(text,form,field,html_options={})

      options = { :size  => 15,
                  :class => "money_us",
                  :dir   => "rtl" ,
                  :step  => ".01"}.merge(html_options)

      %Q{ <td><label>#{text}</label>
          	#{form.telephone_field field,options}
          </td> }.html_safe
  end

  def panel_field_us_label(text,form,field,html_options={})

      options = { :class => "money_us panel-field",
                  :dir   => "rtl" ,
                  :step  => ".01"}.merge(html_options)

      %Q{ <td><label>#{text}</label>
            #{form.telephone_field field,options}
          </td> }.html_safe
  end


  def panel_field_d3_label(text,form,field,html_options={})

      options = { :class => "money_3 panel-field",
                  :dir   => "rtl" ,
                  :step  => ".01"}.merge(html_options)

      %Q{ <td><label>#{text}</label>
            #{form.telephone_field field,options}
          </td> }.html_safe
  end


  def field_gs(text,form,field,html_options={})
      options = { :size  => 15,
                  :class => "money_gs",
                  :precision => 0,
                  :dir   => "rtl",
                  :step  => "any" }.merge(html_options)

      %Q{ <td align="right">#{text}</td>
          <td>#{form.telephone_field field,options}</td> }.html_safe
  end

  def field_gs_label(text,form,field,html_options={})
      options = { :size  => 15,
                  :class => "money_gs",
                  :precision => 0,
                  :dir   => "rtl",
                  :step  => "any" }.merge(html_options)

      %Q{ <td style='padding-bottom: 5px'>
            <label>#{text}</label>
        		#{form.telephone_field field,options}
          </td> }.html_safe
  end


    def field_p4_label(text,form,field,html_options={})

        options = { :size  => 15,
                    :class => "money_ds",
                    :dir   => "rtl" ,
                    :precision => 4,
                    :step  => ".01"}.merge(html_options)

      %Q{ <td style='padding-bottom: 5px'>
            <label>#{text}</label>
            #{form.telephone_field field,options}
          </td> }.html_safe


    end


  def panel_field_gs_label(text,form,field,html_options={})
      options = { :class => "money_gs panel-field",
                  :precision => 0,
                  :dir   => "rtl",
                  :step  => "any" }.merge(html_options)

      %Q{ <td style='padding-bottom: 5px'>
            <label>#{text}</label>
            #{form.telephone_field field,options}
          </td> }.html_safe
  end

    
    def field_p4(text,form,field,html_options={})

        options = { :size  => 15,
                    :class => "money_ds",
                    :dir   => "rtl" ,
                    :step  => ".01"}.merge(html_options)

        %Q{ <td align="right">#{text}</td>
            <td>#{form.telephone_field field,options}</td> }.html_safe


    end  

    def field_text(text,colsp,form,field,size,prox_field,html_options={})

        options = {:size       => size,
                   :onkeyup    => "f(this),EnterTab(event,'#{prox_field}')",
                   :onkeydown  => "f(this)",
                   :onkeypress => "return bloqEnter(event)" }.merge(html_options)

        %Q{ <td align="right">#{text}</td>
            <td colspan="#{colsp}">#{form.text_field field, options}</td> }.html_safe
            

    end

    def field_data(form,field,size,prox_field,html_options={})
      options = {:size       => size,
                 :onkeyup    => "Formatadata(this,event),EnterTab(event,'#{prox_field}')",
                 :onkeypress => "return bloqEnter(event)" }.merge(html_options)

      %Q{ #{form.text_field field,options} }.html_safe
    end

    
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(Rails.root) + '/assets/images/' + image
    tag(:img, options)
	end

  def section(title="", &block)
    content_tag :div, :class => "section" do
      html  = ""
      html  += content_tag :h3, title if title.present?
      html  += content_tag :div, :class => "in", &block
      html.html_safe
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to_function(name, '#', class: "add_fields btn btn-blue", data: {id: id, fields: fields.gsub("\n", "")})
  end 

  def format_decimal(valor)
    number_to_currency( valor, format: '%n', separator: "," )
  end

  def format_peso(valor)
    number_to_currency( valor, format: '%n', precision: 3, separator: "," )
  end

  def format_int(valor)
    number_to_currency( valor, format: '%n', precision: 0 )
  end


   def custom_field_input(form, custom_field)
        form.text_field custom_field.internal_name, id: custom_field.internal_name
    end
end

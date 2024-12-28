module MoedasHelper

  def include_buttons_moedas
    ret = "
        function createMoedasBtns(){
            var txt_search = new Ext.form.TextField({name: 'search'});
            /*var cb_search =
                      new Ext.form.ComboBox({
                            store: ['name'],
                            emptyText: 'Select...',
                            value: 'nome',
                            typeAhead: true,
                            forceSelection: true,
                            triggerAction: 'all',
                            selectOnFocus:true,
                            editable: false
                      });*/
            var retArray =
            [
                      new Ext.Button ({ text: 'Nuevo',
                                        id: 'btnNew',
                                        iconCls: '../images/drop-add.gif',
                                        handler: function(){ document.location.href = '/moedas/new'; },
                                        tooltip: 'Nuevo',
                                     }),
                          new Ext.Spacer({width: 20}),
                          new Ext.form.Label({text: '', id: 'lblSearch' }),
                          //cbPesquisa,
                          txt_search,
                          new Ext.Button ({
                                            text: 'Buscar',
                                            iconCls: 'searchButton',
                                            id: 'btnSearch',
                                            handler: function(){
                                              //filtroColuna = cbPesquisa.getValue();
                                              args_txt = txt_search.getValue();
                                              /*if(filtroColuna == '' || filtroColuna == null){
                                                Ext.Msg.alert('Erro', 'Selecione uma coluna para filtrar!');
                                              }else{*/
                                                //store_Moedas.baseParams.findby = filtroColuna;
                                                store_Moedas.baseParams.query = args_txt;
                                                store_Moedas.load({params: {start:0 , limit:10}});
                                              //}
                                        }
                                       })
                    ]
              return retArray;
          }
    "
    return ret
  end

end

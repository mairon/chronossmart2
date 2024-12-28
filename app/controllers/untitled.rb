        cliente = {
                      contribuyente: true,
                      codigo: params[:persona_id].to_s.rjust(6,'0'),
                      razonSocial: params[:persona_nome],
                      nombreFantasia: pers.nome,
                      tipoOperacion: 2,
                      tipoContribuyente: 2,
                      documentoNumero: params[:ruc],                      
                      direccion: pers.direcao,
                      documentoTipo: 1,
                      pais: 'PRY',
                      paisDescripcion: 'Paraguay',
                      numeroCasa: "0",
                      departamento: pers.cidade.distrito.estado.api_id,
                      distrito: pers.cidade.distrito.api_id,
                      ciudad: pers.cidade.api_id,
                      email: pers.email
                  }
class Abastecida < ActiveRecord::Base

def self.get_abastecidas_sql
  postgres = nil

  begin
    # Conecta ao PostgreSQL
    postgres = PG.connect :host => '38.52.135.201', :port => 5500, :dbname => 'postgres', :user => 'postgres', :password => 'Ask936tjh1245mnbvcxz'

    # Busca registros não processados
    tables = postgres.exec('SELECT ID, valor, chave, litros, preco, bico, data, hora FROM ABASTECIDAS WHERE STATUS = 0 ORDER BY ID')

    # Processa cada registro
    tables.each do |t|
      begin
        # Inicia transação no PostgreSQL para este registro
        postgres.exec('BEGIN')

        # Tenta criar o registro local
        ab = Abastecida.create!(
          api_id: t['id'],
          chave: t['chave'],
          litros: t['litros'].to_f,
          preco: t['preco'].to_f,
          bico: t['bico'],
          data: t['data'],
          valor: t['valor'].to_f,
          hora: (Time.parse(t['hora']) - 3.hours),
          status: 0
        )

        # Se chegou até aqui, o registro foi criado com sucesso
        # Agora pode atualizar o status no PostgreSQL
        postgres.exec("UPDATE ABASTECIDAS SET STATUS = 1 WHERE ID = #{t['id']}")

        # Confirma a transação
        postgres.exec('COMMIT')

        puts "Registro ID #{t['id']} processado com sucesso"

      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
        # Erro ao salvar no banco local - desfaz transação
        postgres.exec('ROLLBACK') if postgres
        puts "Erro ao criar registro ID #{t['id']}: #{e.message}"

      rescue PG::Error => e
        # Erro no PostgreSQL - desfaz transação
        postgres.exec('ROLLBACK') if postgres
        puts "Erro no PostgreSQL para registro ID #{t['id']}: #{e.message}"

      rescue StandardError => e
        # Outros erros - desfaz transação
        postgres.exec('ROLLBACK') if postgres
        puts "Erro inesperado para registro ID #{t['id']}: #{e.message}"
      end
    end

  rescue PG::Error => e
    puts "Erro de conexão com PostgreSQL: #{e.message}"

  rescue StandardError => e
    puts "Erro inesperado na rotina: #{e.message}"

  ensure
    # Fecha conexão se ainda estiver aberta
    postgres&.close
  end
end

end
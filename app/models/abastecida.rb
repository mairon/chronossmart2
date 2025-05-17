class Abastecida < ActiveRecord::Base

	def self.get_abastecidas_sql
		postgres = PG.connect :host => '38.52.135.201', :port => 5500, :dbname => 'postgres', :user => 'postgres', :password => 'Ask936tjh1245mnbvcxz'
   	tables = postgres.exec('SELECT ID, valor, chave, litros, preco, bico, data,hora FROM ABASTECIDAS WHERE STATUS = 0 ORDER BY ID')

   	tables.each do |t|
   		ab = Abastecida.create(
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
   		postgres.exec("UPDATE ABASTECIDAS SET STATUS = 1 WHERE ID = #{ab.api_id}")
   	end

  end

end
class Recalculo < ActiveRecord::Base

	def self.gera_recalculo_entrada(params)

			last_stock = Stock.where("tabela_id <> #{params[:tabela_id]} and deposito_id = #{params[:deposito_id]} and produto_id = #{params[:produto_id]} AND DATA < '#{params[:data]}'").sum('entrada - saida')
			last_custo = Stock.select('promedio_guarani,promedio_dolar').where("tabela = '#{params[:tabela]}' and tabela_id <> #{params[:tabela_id]} and status = 0 and entrada > 0 and deposito_id = #{params[:deposito_id]} and produto_id = #{params[:produto_id]} AND DATA < '#{params[:data]}'").last
		  saldo_stock       = last_stock.to_f
		  saldo_stock_calc  = last_stock.to_f
		  if last_stock.to_f > 0
			  promedio_stock_gs = last_custo.promedio_guarani
			  promedio_stock_us = last_custo.promedio_dolar

			  total_stock_gs = last_custo.promedio_guarani.to_f * last_stock.to_f
			  total_stock_us = last_custo.promedio_dolar.to_f * last_stock.to_f

			else	  	
			  promedio_stock_gs = 0
			  promedio_stock_us = 0

			  total_stock_gs = 0
			  total_stock_us = 0

		  end

		  depositos = Stock.all( select: 'deposito_id', :conditions => ["produto_id = #{params[:produto_id]} AND DATA >= '#{params[:data]}'"], group: 'deposito_id', order: 'deposito_id' )

		  depositos.each do |dp|

			  novo = Stock.all( :select     => 'id,produto_id,tabela_id,deposito_id,entrada,saida,unitario_guarani,unitario_dolar,tabela,promedio_guarani,data,status', 
			                            :conditions => ["deposito_id = #{dp.deposito_id} and produto_id = #{params[:produto_id]} AND DATA >= '#{params[:data]}'"], 
			                            :order      => 'produto_id,data,status,id' )

		  	novo.each do |prod_rec|

			    saldo_stock += ( prod_rec.entrada.to_f - prod_rec.saida.to_f )
			    saldo_stock_calc += ( prod_rec.entrada.to_f - prod_rec.saida.to_f )

			    #ZERA CUSTO
			    if saldo_stock.to_f < 0
			      promedio_stock_gs = promedio_stock_gs 
			      promedio_stock_us = promedio_stock_us
			      saldo_stock_calc  = 0

			      valor_stock_gs = 0
			      valor_stock_us = 0                    
			    end

			    if saldo_stock.to_f == 0
			      promedio_stock_gs = promedio_stock_gs 
			      promedio_stock_us = promedio_stock_us 
			      saldo_stock_calc  = 0		      
			      valor_stock_gs = 0
			      valor_stock_us = 0                    
			      total_stock_gs = 0
			      total_stock_us = 0

			    end

			    #RECALCULO CUSTO ENTRADA
			    if ( prod_rec.entrada.to_f > 0 and prod_rec.status.to_i == 0 and saldo_stock.to_f > 0 and prod_rec.tabela != 'TRANSFERENCIA_DEPOSITOS' )  
			      total_stock_gs += ( prod_rec.entrada.to_f * prod_rec.unitario_guarani.to_f ) 
			      total_stock_us += ( prod_rec.entrada.to_f * prod_rec.unitario_dolar.to_f ) 

			      promedio_stock_gs = ( total_stock_gs.to_f / saldo_stock.to_f ) 
			      promedio_stock_us = ( total_stock_us.to_f / saldo_stock.to_f ) 

			    end

			    if ( prod_rec.tabela == 'TRANSFERENCIA_DEPOSITOS' and prod_rec.entrada.to_f > 0 and saldo_stock.to_f != 0)

			    	find_saida = Stock.find_by_tabela_id(prod_rec.tabela_id, conditions: "tabela = 'TRANSFERENCIA_DEPOSITOS' and saida > 0", select: 'unitario_guarani,unitario_dolar,promedio_guarani,promedio_dolar')
			      
			      puts  "#{prod_rec.data} - #{total_stock_gs.to_s}"
			      total_stock_gs += ( prod_rec.entrada.to_f * find_saida.promedio_guarani.to_f )
			      total_stock_us += ( prod_rec.entrada.to_f * find_saida.promedio_dolar.to_f ) 

			      puts  "#{prod_rec.data} - #{total_stock_gs.to_s} / #{saldo_stock.to_s} | #{prod_rec.entrada.to_f} * #{find_saida.unitario_guarani.to_f}"
	          if saldo_stock.to_f > 0
				      promedio_stock_gs = ( total_stock_gs.to_f / saldo_stock.to_f ) 
				      promedio_stock_us = ( total_stock_us.to_f / saldo_stock.to_f )           	
	          end
			    end

			    if ( prod_rec.saida.to_f > 0 and saldo_stock.to_f != 0 )          
			      total_stock_gs -= ( prod_rec.saida.to_f * promedio_stock_gs.to_f ) 
			      total_stock_us -= ( prod_rec.saida.to_f * promedio_stock_us.to_f ) 
			    end

				  #atulizacoes
				  if ( prod_rec.tabela == 'TRANSFERENCIA_DEPOSITOS' and prod_rec.saida.to_f > 0 and  saldo_stock.to_f > 0)
						prod_rec.update_attributes(recalc: true, saldo_guarani: total_stock_gs, saldo: saldo_stock.to_f, promedio_guarani: promedio_stock_gs.to_f, promedio_dolar: promedio_stock_us.to_f, unitario_guarani: promedio_stock_gs.to_f, unitario_dolar: promedio_stock_us.to_f)

				  elsif ( prod_rec.tabela == 'TRANSFERENCIA_DEPOSITOS' and prod_rec.entrada.to_f > 0 and  saldo_stock.to_f > 0)
						prod_rec.update_attributes(recalc: true, saldo_guarani: total_stock_gs, saldo: saldo_stock.to_f, promedio_guarani: promedio_stock_gs.to_f, promedio_dolar: promedio_stock_us.to_f, unitario_guarani: find_saida.promedio_guarani.to_f, unitario_dolar: find_saida.promedio_dolar.to_f)
					else
				  	prod_rec.update_attributes(recalc: true, saldo_guarani: (promedio_stock_gs.to_f * saldo_stock.to_f), saldo: saldo_stock.to_f, promedio_guarani: promedio_stock_gs.to_f, promedio_dolar: promedio_stock_us.to_f)
				  end
		  	end
			  #zera quando muda o deposito
			  saldo_stock       = 0
			  valor_stock_gs    = 0
			  valor_stock_us    = 0

			  promedio_stock_gs = 0
			  promedio_stock_us = 0

			  total_stock_gs = 0
			  total_stock_us = 0		  
		  end
	  end

		def self.gera_recalculo_individual(params)
	    sql_dist = "SELECT DISTINCT ON (S.DEPOSITO_ID) S.DEPOSITO_ID,
	                       S.PRODUTO_ID

													FROM STOCKS S
													WHERE S.PRODUTO_ID = #{params[:produto_id]}"


	    "SELECT DISTINCT ON (S.PRODUTO_ID) S.PRODUTO_ID,
	                       S.DEPOSITO_ID
													FROM STOCKS S
													WHERE S.DEPOSITO_ID = 1"

	    recalc = Stock.find_by_sql(sql_dist)

		  saldo_stock       = 0
		  saldo_stock_calc  = 0
		  valor_stock_gs    = 0
		  valor_stock_us    = 0

		  promedio_stock_gs = 0
		  promedio_stock_us = 0

		  total_stock_gs = 0
		  total_stock_us = 0

	    recalc.each do |r|
			  saldo_stock       = 0
			  saldo_stock_calc  = 0
			  valor_stock_gs    = 0
			  valor_stock_us    = 0

			  promedio_stock_gs = 0
			  promedio_stock_us = 0

			  total_stock_gs = 0
			  total_stock_us = 0
		  novo = Stock.all( :select     => 'id,produto_id,tabela_id,deposito_id,entrada,saida,unitario_guarani,unitario_dolar,tabela,promedio_guarani,data,status', 
		                            :conditions => ["deposito_id = #{r.deposito_id} and produto_id = #{r.produto_id}"], 
		                            :order      => 'produto_id, data,status,id' )
		  novo.each do |prod_rec|

		    saldo_stock += ( prod_rec.entrada.to_f - prod_rec.saida.to_f )
		    saldo_stock_calc += ( prod_rec.entrada.to_f - prod_rec.saida.to_f )

		    #ZERA CUSTO
		    if saldo_stock.to_f < 0
		      promedio_stock_gs = promedio_stock_gs 
		      promedio_stock_us = promedio_stock_us
		      saldo_stock_calc  = 0

		      valor_stock_gs = 0
		      valor_stock_us = 0                    
		    end

		    if saldo_stock.to_f == 0
		      promedio_stock_gs = promedio_stock_gs 
		      promedio_stock_us = promedio_stock_us 
		      saldo_stock_calc  = 0		      
		      valor_stock_gs = 0
		      valor_stock_us = 0                    
		      total_stock_gs = 0
		      total_stock_us = 0

		    end

		    #RECALCULO CUSTO ENTRADA
		    if ( prod_rec.entrada.to_f > 0 and prod_rec.status.to_i == 0 and saldo_stock.to_f > 0 and prod_rec.tabela != 'TRANSFERENCIA_DEPOSITOS' )  
		      total_stock_gs += ( prod_rec.entrada.to_f * prod_rec.unitario_guarani.to_f ) 
		      total_stock_us += ( prod_rec.entrada.to_f * prod_rec.unitario_dolar.to_f ) 

		      promedio_stock_gs = ( total_stock_gs.to_f / saldo_stock.to_f ) 
		      promedio_stock_us = ( total_stock_us.to_f / saldo_stock.to_f ) 

		    end

		    if ( prod_rec.tabela == 'TRANSFERENCIA_DEPOSITOS' and prod_rec.entrada.to_f > 0 and saldo_stock.to_f != 0)

		    	find_saida = Stock.find_by_tabela_id(prod_rec.tabela_id, conditions: "tabela = 'TRANSFERENCIA_DEPOSITOS' and saida > 0", select: 'unitario_guarani,unitario_dolar,promedio_guarani,promedio_dolar')
		      
		      puts  "#{prod_rec.data} - #{total_stock_gs.to_s}"
		      total_stock_gs += ( prod_rec.entrada.to_f * find_saida.promedio_guarani.to_f )
		      total_stock_us += ( prod_rec.entrada.to_f * find_saida.promedio_dolar.to_f ) 

		      puts  "#{prod_rec.data} - #{total_stock_gs.to_s} / #{saldo_stock.to_s} | #{prod_rec.entrada.to_f} * #{find_saida.unitario_guarani.to_f}"
          if saldo_stock.to_f > 0
			      promedio_stock_gs = ( total_stock_gs.to_f / saldo_stock.to_f ) 
			      promedio_stock_us = ( total_stock_us.to_f / saldo_stock.to_f )           	
          end
		    end

		    if ( prod_rec.saida.to_f > 0 and saldo_stock.to_f != 0 )          
		      total_stock_gs -= ( prod_rec.saida.to_f * promedio_stock_gs.to_f ) 
		      total_stock_us -= ( prod_rec.saida.to_f * promedio_stock_us.to_f ) 
		    end

			  #atulizacoes
			  if ( prod_rec.tabela == 'TRANSFERENCIA_DEPOSITOS' and prod_rec.saida.to_f > 0 and  saldo_stock.to_f > 0)
					prod_rec.update_attributes(recalc: true, saldo_guarani: total_stock_gs, saldo: saldo_stock.to_f, promedio_guarani: promedio_stock_gs.to_f, promedio_dolar: promedio_stock_us.to_f, unitario_guarani: promedio_stock_gs.to_f, unitario_dolar: promedio_stock_us.to_f)

			  elsif ( prod_rec.tabela == 'TRANSFERENCIA_DEPOSITOS' and prod_rec.entrada.to_f > 0 and  saldo_stock.to_f > 0)
					prod_rec.update_attributes(recalc: true, saldo_guarani: total_stock_gs, saldo: saldo_stock.to_f, promedio_guarani: promedio_stock_gs.to_f, promedio_dolar: promedio_stock_us.to_f, unitario_guarani: find_saida.promedio_guarani.to_f, unitario_dolar: find_saida.promedio_dolar.to_f)
				else
			  	prod_rec.update_attributes(recalc: true, saldo_guarani: (promedio_stock_gs.to_f * saldo_stock.to_f), saldo: saldo_stock.to_f, promedio_guarani: promedio_stock_gs.to_f, promedio_dolar: promedio_stock_us.to_f)
			  end
		  end
		  #zera quando muda o deposito
		  saldo_stock       = 0
		  valor_stock_gs    = 0
		  valor_stock_us    = 0

		  promedio_stock_gs = 0
		  promedio_stock_us = 0

		  total_stock_gs = 0
		  total_stock_us = 0		  
	  end
  end
end

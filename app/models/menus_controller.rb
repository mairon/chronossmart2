class MenusController < ApplicationController

before_filter :authenticate

  def index
    sql = "SELECT P.ID, P.NOME, P.STOCK_MINIMO, SUM(S.ENTRADA - S.SAIDA) AS STOCK FROM PRODUTOS P, STOCKS S 
           WHERE P.ID = S.PRODUTO_ID
           GROUP BY 
           P.ID, P.NOME, P.STOCK_MINIMO
           HAVING 
           SUM(S.ENTRADA - S.SAIDA) <= P.STOCK_MINIMO
           ORDER BY 
           1"    

 #   @stock_minimo = Produto.find_by_sql( sql )


 #   @aniversarios = Persona.all( :select => "id,nome,email",
 #                                :conditions => ["date_part('day',data_nascimento)= '#{Time.now.strftime("%d")}' AND date_part('month', data_nascimento) = '#{Time.now.strftime("%m")}' "],
 #                                :order => "2" )

  end



end


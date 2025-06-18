class SuportesController < ApplicationController

	def comando
	end

    def consulta
        datas = [
        '3f',
        'agro_cordillera',
        'baby_shop',
        'beux',
        'bi',
        'carlos_bambu',
        'casa_blanca',
        'casa_moeda',
        'cec',
        'chronos_adm',
        'crescer',
        'dasilva',
        'datasafer',
        'davila',
        'ddn',
        'distriagro',
        'doria',
        'ducampo',
        'impactus',
        'itatec',
        'jk_service',
        'luffe',
        'luz_ma',
        'maxshop',
        'megacenter',
        'menegaz',
        'patron',
        'planner',
        'pointer',
        'santa_catalina',
        'santacatalinamt',
        'srvtecnet',
        'teccursos',
        'tecno_tierra',
        'theboss',
        'thomaze',
        'tork_performace',
        'vmmujer',
        'rodoeste',
        'hanor',
        'mikaelito'
        ]


    datas.each do |db|
       postgres = PG.connect :host => 'db-postgresql-chronos2-do-user-6983944-0.b.db.ondigitalocean.com', :port => 25060, :dbname => db, :user => 'doadmin', :password => 'AVNS_fJ3ugqAKe6m7keYRk-w'


       tables = postgres.exec(params[:consulta])

       puts "Gerado #{db}"

       puts postgres.close

    end

    redirect_to comando_suportes_path

    flash[:notice] = 'Processo Efetuado con Exito!'
  end
end

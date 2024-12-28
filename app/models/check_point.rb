class CheckPoint < ActiveRecord::Base
  belongs_to :persona

    def self.import(file, params)

      CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8', :header_converters => :symbol, :row_sep => :auto, :col_sep => ",") do |row|
        company_hash = CheckPoint.new
        company_hash.unidade_id = params[:unidade_id]
        company_hash.persona_id = row[0]
        company_hash.checkpoint = row[1]
        company_hash.check_point_type = row[3]
        company_hash.import = true
        company_hash.save
      end

  end
end

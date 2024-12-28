
class ImportaDados < ActiveRecord::Base
	require 'csv'
	def self.import(file)
		CSV.foreach(file.path.encode!("utf-8", "utf-8", :invalid => :replace), headers: true) do |row|
			Menu.create! row.to_hash
		end
	end
end

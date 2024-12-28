class Localizacao < ActiveRecord::Base
    validates :ocupacao, :sigla, :presence => true
end

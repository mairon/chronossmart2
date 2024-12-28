class Predio < ActiveRecord::Base
  has_many :apartamentos, :dependent => :destroy
end

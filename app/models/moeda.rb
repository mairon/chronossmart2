class Moeda < ActiveRecord::Base
  validates_uniqueness_of :data, :message => " ja cadastrado."
  validates_presence_of :dolar_compra, :dolar_venda 
	validates :dolar_compra, :dolar_venda, :real_compra, :real_venda, :rs_us_compra, :rs_us_venda, :ps_gs_compra, :ps_gs_venda, :numericality =>  { :greater_than => 0 }   
end

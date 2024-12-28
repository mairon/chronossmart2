class Pagare < ActiveRecord::Base
  has_many :pagares_detalhes,   :order => 1, :dependent => :destroy
  
  validates_presence_of :persona_nome,:persona_ruc,:valor_guarani,:valor_dolar,:cota

  after_save :gera_cota
  
  def gera_cota
    PagaresDetalhe.destroy_all("pagare_id = #{self.id}" )
    cota = 1
    venc = 30
    valor_gs = self.valor_guarani / self.cota
    valor_us = self.valor_dolar / self.cota
    self.cota.times do
      PagaresDetalhe.create( :pagare_id       => self.id.to_i,
                                             :cota                => cota,
                                             :valor_guarani => valor_gs.to_f,   
                                             :valor_dolar     => valor_us.to_f,   
                                             :vencimento    => self.data + venc )
      cota += 1 
      venc += 30                      
    end                       

  end 
  
end

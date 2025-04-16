class Afericao < ActiveRecord::Base
  validates :persona_id, :quantidade, :produto_id,
            :deposito_id, :deposito_origem_id, presence: true

  before_save :custo_medio
  def custo_medio
    ultimo_promedio = Stock.last(:conditions => ["deposito_id = ? and produto_id = ? AND data <= ?",self.deposito_origem_id, self.produto_id, self.data], select: 'produto_id,promedio_guarani,promedio_dolar', order: 'data,id')
    if ultimo_promedio
      self.promedio_guarani = ultimo_promedio.promedio_guarani.to_f
    end 
  end

end

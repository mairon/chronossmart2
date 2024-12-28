class DiarioHaber < ActiveRecord::Base
belongs_to :diario

  validates_presence_of :valor_guarani,
                        :valor_dolar


  def before_save

    @rubro = Rubro.find_by_id(self.rubro_id);
    self.descricao = @rubro.descricao.to_s unless self.rubro_id.blank?
  end

end

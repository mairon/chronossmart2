class ComprasDocumento < ActiveRecord::Base

  belongs_to :compra
  belongs_to :documento

  validates_length_of   :documento_numero_01,
                        :documento_numero_02, :maximum=>3,:message => "Tiene mas Numero do que lo permitido"

  validates_uniqueness_of :documento_numero  , :scope=>[:persona_id,:documento_numero_01, :documento_numero_02], :message => " ja cadastrado."

  before_save :calcs
  def calcs          #
    @documento          = Documento.find_by_id(self.documento_id);
    self.documento_nome = @documento.nome.to_s;

    @persona          = Persona.find_by_id(self.persona_id);
    self.persona_nome = @persona.nome.to_s;
    self.persona_ruc  = @persona.ruc.to_s;

    rubro = Rubro.find_by_id(self.rubro_id,:select => 'id,descricao,codigo')
    self.rubro_nome    = rubro.descricao.to_s unless self.rubro_id.blank?

  end

end

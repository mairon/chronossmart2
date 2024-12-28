class FechamentoTurno < ActiveRecord::Base

  validates_presence_of :inicio,:final

  def before_save

    @turno          = Turno.find_by_id(self.turno_id);
    self.turno_nome = @turno.nome.to_s;

    @bomba          = Bomba.find_by_id(self.bomba_id);
    self.bomba_nome    = @bomba.nome.to_s;
    self.deposito_id   = @bomba.deposito_id.to_i;
    self.deposito_nome = @bomba.deposito_nome.to_s;

  end


end

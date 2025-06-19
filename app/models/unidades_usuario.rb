class UnidadesUsuario < ActiveRecord::Base
  belongs_to :unidade

  # Scope otimizado para menu
  scope :with_unidade_data, lambda { |usuario_id|
    joins(:unidade)
    .where(usuario_id: usuario_id)
    .select("unidades_usuarios.id, unidades.unidade_nome, unidades_usuarios.unidade_id")
  }

  # Cache das unidades do usuário
  def self.cached_for_user(usuario_id)
    Rails.cache.fetch("unidades_usuario_#{usuario_id}", expires_in: 30.minutes) do
      with_unidade_data(usuario_id).to_a
    end
  end

  after_create :clear_user_cache
  after_update :clear_user_cache
  after_destroy :clear_user_cache

  private

  def clear_user_cache
    Rails.cache.delete("unidades_usuario_#{self.usuario_id}")
    Rails.cache.delete("user_menu_units_#{self.usuario_id}")
  end
end

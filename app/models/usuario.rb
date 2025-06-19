class Usuario < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  validates_presence_of   :usuario_nome,:usuario_senha
  validates_uniqueness_of :usuario_nome
  has_and_belongs_to_many :unidades
  has_and_belongs_to_many :contas
  has_many :usuario_perfils, :dependent => :destroy
  has_many :tarefas
  belongs_to :persona
  belongs_to :centro_custo

  # Cache que considera a unidade atual
  def cached_menu_code_for_unidade(unidade_id = nil)
    unidade_id ||= Thread.current[:current_unidade_id]
    cache_key = "user_menu_#{self.id}_unidade_#{unidade_id}"

    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      self.menu_code || ''
    end
  end

  def cached_unidades_for_select
    Rails.cache.fetch("user_unidades_#{self.id}", expires_in: 30.minutes) do
      UnidadesUsuario.joins(:unidade)
                     .where(usuario_id: self.id)
                     .select('unidades_usuarios.id, unidades.unidade_nome, unidades_usuarios.unidade_id')
                     .map { |p| [p.unidade_nome, p.unidade_id] }
    end
  end

  # Limpa cache quando usuário é atualizado
  after_update :clear_user_cache
  after_destroy :clear_user_cache

  private

  def clear_user_cache
    # Lista de chaves para limpar
    cache_patterns = [
      "usuario_#{self.id}",
      "user_menu_#{self.id}_*",
      "user_unidades_#{self.id}",
      "user_menu_data_u#{self.id}_*"
    ]

    # No Rails 3.2, não tem delete_matched, então limpamos individualmente
    cache_patterns.each do |pattern|
      if pattern.include?('*')
        # Para padrões com wildcard, limpamos chaves conhecidas
        base = pattern.gsub('*', '')
        (1..10).each do |i|  # Assume máximo 10 unidades
          Rails.cache.delete("#{base}un#{i}")
        end
      else
        Rails.cache.delete(pattern)
      end
    end
  end
end

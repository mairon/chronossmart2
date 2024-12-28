module TranslationsHelper
  def translation_keys
    Translation.select('distinct(key)').order('key')
  end

  def translation_for_key(translations, key)
    hits = translations.to_a.select {|t| t.key == key}
    hits.first
  end

  def all_locales
    Translation.select("DISTINCT(locale)")
  end
end

json.array!(@class_spellbooks) do |class_spellbook|
  json.extract! class_spellbook, :id, :character_class_id, :spell_id, :level
  json.url class_spellbook_url(class_spellbook, format: :json)
end

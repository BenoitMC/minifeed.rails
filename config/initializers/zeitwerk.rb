Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect("keyboard_shortcuts" => "KEYBOARD_SHORTCUTS")
end

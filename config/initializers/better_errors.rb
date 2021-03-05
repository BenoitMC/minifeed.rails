if defined? BetterErrors
  BetterErrors.editor = (ENV["RAILS_EDITOR"].presence || :atom).to_sym
end

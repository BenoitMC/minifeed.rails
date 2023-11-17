SimpleCov.merge_timeout 3600
SimpleCov.start "rails" do
  Dir.glob(File.join("app", "**")).each do |path|
    path = Pathname.new(path)
    add_group path.basename.to_s.capitalize, path.to_path
  end
end

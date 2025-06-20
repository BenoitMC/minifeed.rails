SimpleCov.merge_timeout 3600

SimpleCov.start "rails" do
  if $PROGRAM_NAME.include?("rspec")
    if ARGV.join(" ").match?(/exclude.+system/)
      command_name "rspec_unit"
    elsif ARGV.join(" ").match?(/pattern.+system/)
      command_name "rspec_system"
    end
  end

  Dir.glob(File.join("app", "**")).each do |path|
    path = Pathname.new(path)
    add_group path.basename.to_s.capitalize, path.to_path
  end
end

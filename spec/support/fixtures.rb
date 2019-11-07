RSpec.configure do
  def fixture_file_path(file)
    Rails.root.join("spec", "fixtures", file)
  end

  def fixture_content(file)
    fixture_file_path(file).read
  end
end

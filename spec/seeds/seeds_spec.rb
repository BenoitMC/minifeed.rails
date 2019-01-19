require "rails_helper"

describe "seeds" do
  it "should create sample data" do
    load Rails.root.join("db", "seeds.rb")
    expect(User.count).to eq 1
    expect(User.last_created.is_admin).to eq true
    expect(Category.count).to eq 2
    expect(Feed.count).to eq 5
  end

  it "should create nothing if any user exists" do
    create(:user)
    load Rails.root.join("db", "seeds.rb")
    expect(User.count).to eq 1
    expect(Category.count).to eq 0
    expect(Feed.count).to eq 0
  end
end # describe "seeds"

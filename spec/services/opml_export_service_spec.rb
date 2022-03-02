require "rails_helper"

describe OpmlExportService do
  let(:user) { create(:user, email: "user@example.org") }

  let!(:category) { create(:category, user:, name: "Category Name") }

  let!(:feed) {
    create(:feed,
      :user     => user,
      :category => category,
      :name     => "Feed Name",
      :url      => "https://example.org/feed.xml",
    )
  }

  it "should generate OPML" do
    generated_opml = described_class.call(user)

    expected_opml = <<~OPML
      <?xml version="1.0" encoding="UTF-8"?>
      <opml version="1.0">
        <head>
          <title>Minifeed OPML of user@example.org</title>
        </head>
        <body>
          <outline text="Category Name" title="Category Name">
            <outline text="Feed Name" title="Feed Name" xmlUrl="https://example.org/feed.xml"/>
          </outline>
        </body>
      </opml>
    OPML

    expect(generated_opml.strip).to eq expected_opml.strip
  end
end

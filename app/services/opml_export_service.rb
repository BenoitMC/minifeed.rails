class OpmlExportService < ApplicationService
  initialize_with :user

  def call
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.opml(version: "1.0") do
        xml.head do
          xml.title "Minifeed OPML of #{user}"
        end
        xml.body do
          categories.each do |category|
            xml.outline(text: category.name, title: category.name) do
              category.feeds.each do |feed|
                xml.outline(text: feed.name, title: feed.name, xmlUrl: feed.url)
              end
            end
          end # categories.each
        end # xml.body
      end # xml.open
    end # build

    builder.to_xml
  end

  private

  def categories
    Pundit.policy_scope!(user, Category)
  end
end

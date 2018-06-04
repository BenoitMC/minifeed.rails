class Settings::OpmlExportsController < ApplicationController
  skip_after_action :verify_policy_scoped

  def create
    opml = OpmlExportService.call(current_user)
    send_data opml, type: "application/octet-stream", filename: "minifeed.opml.xml"
  end
end

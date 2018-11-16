class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Agilibox::ActiveRecordUUIDConcern
  include Agilibox::ModelI18n
  include Agilibox::ModelToS
  include Agilibox::Search
  include Agilibox::TimestampHelpers

  nilify_blanks before: :validation
end

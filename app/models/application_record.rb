class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include BMC::ActiveRecordUUIDConcern
  include BMC::ModelI18n
  include BMC::ModelToS
  include BMC::Search
  include BMC::TimestampHelpers

  nilify_blanks before: :validation

  def self.string_enum(column, values, **)
    enum column => values.map(&:to_s).index_by(&:itself), **
  end
end

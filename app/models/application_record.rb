class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include SearchModelConcern

  nilify_blanks before: :validation

  before_save :assign_default_uuid

  def self.string_enum(column, values, **)
    enum column, values.map(&:to_s).index_by(&:itself), **
  end

  def self.last_created
    reorder(:id).last
  end

  def self.t(...)
    human_attribute_name(...)
  end

  def to_s
    %w[name title].map do |m|
      return send(m) if respond_to?(m)
    end

    super
  end

  private

  def assign_default_uuid
    self.id ||= SortableUuidGenerator.call
  end
end

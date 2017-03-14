class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  before_save :validate_primary_key_is_uuid

  def validate_primary_key_is_uuid
    unless self.class.columns_hash["id"].type == :uuid
      raise "invalid id type, please change to uuid"
    end
  end
end

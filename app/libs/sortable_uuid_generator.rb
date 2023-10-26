# Microtime based uuids to be sortable
class SortableUuidGenerator
  REGEX_WITH_DASHES    = /^([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{12})$/
  REGEX_WITHOUT_DASHES = /^([0-9a-f]{8})([0-9a-f]{4})([0-9a-f]{4})([0-9a-f]{4})([0-9a-f]{12})$/

  def self.call
    prefix = Time.zone.now.strftime("%s%9N").to_i.to_s(16)
    suffix = SecureRandom.hex(8)
    (prefix + suffix).gsub(REGEX_WITHOUT_DASHES, '\1-\2-\3-\4-\5')
  end
end

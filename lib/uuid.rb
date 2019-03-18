require 'securerandom'

class UUID

  UUID_V4_PATTERN = /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i

  def self.generate
    SecureRandom.uuid
  end

  def self.is_valid_uuid?(string)
    UUID_V4_PATTERN.match?(string)
  end

end
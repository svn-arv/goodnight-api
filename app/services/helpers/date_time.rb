module Helpers
  class DateTime
    def self.parseable?(string)
      raise StandardError unless string.instance_of?(String)

      ::DateTime.parse(string)
      true
    rescue StandardError
      false
    end
  end
end

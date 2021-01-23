module GoPay
  class Version
    MAJOR = 0
    MINOR = 4
    PATCH = 1

    class << self
      def to_s
        [MAJOR, MINOR, PATCH].compact.join('.')
      end
    end
  end
end
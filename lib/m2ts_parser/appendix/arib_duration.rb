module M2TSParser
  module Appendix
    class AribDuration < BinaryParser::TemplateBase
      Def do
        data :hour, BCD, 8
        data :min,  BCD, 8
        data :sec,  BCD, 8
      end

      def content_description
        to_s
      end

      def to_s
        return sprintf("%02d:%02d:%02d", hour.to_i, min.to_i, sec.to_i)
      end

      def to_sec
        return hour.to_i * 3600 + min.to_i * 60 + sec.to_i
      end
    end
  end
end

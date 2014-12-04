# -*- coding: utf-8 -*-
module M2TSParser
  class Code < BinaryParser::TemplateBase
    def to_s
      code.to_s
    end

    def content_description
      to_s
    end

    def names
      []
    end
  end

  class LanguageCode < Code
    Def do
      data :code, Binary, 24
    end
  end

  class CountryCode < Code
    Def do
      data :code, Binary, 24
    end
  end
end

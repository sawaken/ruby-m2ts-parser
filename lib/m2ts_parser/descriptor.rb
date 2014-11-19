# -*- coding: utf-8 -*-
module M2TSParser

  class CountryCode < BinaryParser::TemplateBase
    Def do
      data :code, Binary, 24
    end

    def to_s
      code.to_s
    end
  end

  class ARIBString < BinaryParser::TemplateBase
    def content_description
      if to_s
        arib_str = TSparser::AribString.new(TSparser::Binary.new(to_s))
        return arib_str.to_utf_8
      else
        return ""
      end
    end
  end

  # 6.2.1 ブーケ名記述子 (Bouquet name descriptor)
  class BouquetNameDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,      UInt, 8
      data :descriptor_length,   UInt, 8
      data :chars,             Binary, var(:descriptor_length) * 8
    end
  end

  # 6.2.2 CA 識別記述子 (CA identifier descriptor)
  class CAIdentifierDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,             UInt, 8
      data :descriptor_length,          UInt, 8
      SPEND var(:descriptor_length) * 8, :ca_system_ids, UInt16
    end
  end

  # 6.2.3  コンポーネント記述子 (Component descriptor)
  class ComponentDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,              UInt, 8
      data :descriptor_length,           UInt, 8
      data :reserved_future_use,         UInt, 4
      data :stream_content,              UInt, 4
      data :component_type,              UInt, 8
      data :component_tag,               UInt, 8
      data :iso_639_language_code,     Binary, 24
      data :text,                  ARIBString, var(:descriptor_length) * 8 - 48
    end
  end

  # 6.2.4 コンテント記述子 (Content descriptor)
  class ContentDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,           UInt, 8
      data :descriptor_length,        UInt, 8
      SPEND var(:descriptor_length) * 8, :contents do
        data :content_nibble_level_1, UInt, 4
        data :content_nibble_level_2, UInt, 4
        data :user_nibble1,           UInt, 4  
        data :user_nibble2,           UInt, 4  
      end
    end
  end

  # 6.2.5 国別受信可否記述子 (Country availability descriptor)
  class CountryAvailabilityDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,            UInt, 8
      data :descriptor_length,         UInt, 8
      data :country_availability_flag, UInt, 1
      data :reserved_future_use,       UInt, 1
      SPEND var(:descriptor_length) * 8, :country_codes, CountryCode
    end
  end

  # 6.2.6 衛星分配システム記述子 (Satellite delivery system descriptor)


  # 6.2.7 拡張形式イベント記述子 (Extended event descriptor)


  # 6.2.8 リンク記述子 (Linkage descriptor)


  # 6.2.9 モザイク記述子 (Mosaic descriptor)


  # 6.2.10 NVOD 基準サービス記述子 (Near Video On Demand reference descriptor)


  # 6.2.11 ネットワーク名記述子 (Network name descriptor)


  # 6.2.12 パレンタルレート記述子 (Parental rating descriptor)


  # 6.2.13 サービス記述子 (Service descriptor)


  # 6.2.14 サービスリスト記述子 (Service list descriptor)


  # 6.2.15 短形式イベント記述子 (Short event descriptor)
  class ShortEventDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,              UInt, 8
      data :descriptor_length,           UInt, 8
      data :iso_639_language_code,     Binary, 24
      data :event_name_length,           UInt, 8
      data :event_name,            ARIBString, var(:event_name_length) * 8
      data :text_length,                 UInt, 8
      data :text,                  ARIBString, var(:text_length) * 8
    end
  end

  # 6.2.16 ストリーム識別記述子 (Stream identifier descriptor)


  # 6.2.17 スタッフ記述子 (Stuffing descriptor)


  # 6.2.18 タイムシフトイベント記述子 (Time shifted event descriptor)

  # 6.2.53 データブロードキャスト識別記述子 (data broadcast id descriptor)
  

  # 未定義記述子
  class UndefinedDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,      UInt, 8
      data :descriptor_length,   UInt, 8
      data :entity,            Binary, var(:descriptor_length) * 8
    end
  end

  # 記述子セレクター
  module Descriptor
    DescriptorMapping = {
      0x50 => ComponentDescriptor,
      0x4d => ShortEventDescriptor,
    }
    DescriptorMapping.default = UndefinedDescriptor
      
    def self.new(binary, parent_scope=nil)
      descriptor_tag = binary.sub(:byte_length => 1).to_i
      return DescriptorMapping[descriptor_tag].new(binary)
    end
  end        
end

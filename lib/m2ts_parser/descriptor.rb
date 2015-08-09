# -*- coding: utf-8 -*-
module M2TSParser
  # 6.2.1 ブーケ名記述子 (Bouquet name descriptor)
  # ※ bouquet［ブーケ］：放送事業者から1 つのものとして提供されるサービス（編成チャンネル）の集合。
  class BouquetNameDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,                    UInt, 8
      data :descriptor_length,                 UInt, 8
      data :chars,             Appendix::ARIBString, var(:descriptor_length) * 8
    end
  end

  # 6.2.2 CA 識別記述子 (CA identifier descriptor)
  # ※ Conditional Access (CA) system［限定受信方式］：サービスやイベントの視聴を制御するシステム。
  # ※ 特定のブーケ、サービス、イベント、あるいはコンポーネントが限定受信システムに関係しているか
  #    どうかを示し、さらに限定受信方式識別(CA_system_id)で限定受信システムの種別を示す。
  class CAIdentifierDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,             UInt, 8
      data :descriptor_length,          UInt, 8

      # この16 ビットのフィールドは、CA システムを識別する。
      # このフィールド値の割当ては、標準化機関の規定による。(付録M 参照)
      SPEND var(:descriptor_length) * 8, :ca_system_ids, Appendix::CASystemId
    end
  end

  # 6.2.3  コンポーネント記述子 (Component descriptor)
  # ※ component（エレメンタリーストリーム）［コンポーネント］：イベントを構成する要素。
  #    例えば、映像、音声、文字、各種データなど。
  class ComponentDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,                        UInt, 8
      data :descriptor_length,                     UInt, 8
      data :reserved_future_use,                   UInt, 4
      data :stream_content,                        UInt, 4
      data :component_type,                        UInt, 8
      data :component_tag,                         UInt, 8
      data :iso_639_language_code,         LanguageCode, 24
      data :text,                  Appendix::ARIBString, var(:descriptor_length) * 8 - 48
    end

    # ARIB-STD-B10 第2部 表6-5 「コンポーネント内容とコンポーネント種別」に従う定義
    ComponentMapping = {
      0x01 => {
        0x01 => "映像480i(525i)、アスペクト比4:3",
        0x02 => "映像480i(525i)、アスペクト比16:9 パンベクトルあり",
        0x03 => "映像480i(525i)、アスペクト比16:9 パンベクトルなし",
        0x04 => "映像480i(525i)、アスペクト比 > 16:9",
        0x91 => "映像2160p、アスペクト比4:3",
        0x92 => "映像2160p、アスペクト比16:9 パンベクトルあり",
        0x93 => "映像2160p、アスペクト比16:9 パンベクトルなし",
        0x94 => "映像2160p、アスペクト比 > 16:9",
        0xA1 => "映像480p(525p)、アスペクト比4:3",
        0xA2 => "映像480p(525p)、アスペクト比16:9 パンベクトルあり",
        0xA3 => "映像480p(525p)、アスペクト比16:9 パンベクトルなし",
        0xA4 => "映像480p(525p)、アスペクト比 > 16:9",
        0xB1 => "映像1080i(1125i)、アスペクト比4:3",
        0xB2 => "映像1080i(1125i)、アスペクト比16:9 パンベクトルあり",
        0xB3 => "映像1080i(1125i)、アスペクト比16:9 パンベクトルなし",
        0xB4 => "映像1080i(1125i)、アスペクト比 > 16:9",
        0xC1 => "映像720p(750p)、アスペクト比4:3",
        0xC2 => "映像720p(750p)、アスペクト比16:9 パンベクトルあり",
        0xC3 => "映像720p(750p)、アスペクト比16:9 パンベクトルなし",
        0xC4 => "映像720p(750p)、アスペクト比 > 16:9",
        0xD1 => "映像240p アスペクト比4:3",
        0xD2 => "映像240p アスペクト比16:9 パンベクトルあり",
        0xD3 => "映像240p アスペクト比16:9 パンベクトルなし",
        0xD4 => "映像240p アスペクト比 > 16:9",
        0xE1 => "映像1080p(1125p)、アスペクト比4:3",
        0xE2 => "映像1080p(1125p)、アスペクト比16:9 パンベクトルあり",
        0xE3 => "映像1080p(1125p)、アスペクト比16:9 パンベクトルなし",
        0xE4 => "映像1080p(1125p)、アスペクト比 > 16:9",
        0xF1 => "映像180p アスペクト比4:3",
        0xF2 => "映像180p アスペクト比16:9 パンベクトルあり",
        0xF3 => "映像180p アスペクト比16:9 パンベクトルなし",
        0xF4 => "映像180p アスペクト比 > 16:9",
      },
      0x02 => {
        0x01 => "音声、1/0モード（シングルモノ）",
        0x02 => "音声、1/0＋1/0モード（デュアルモノ）",
        0x03 => "音声、2/0モード（ステレオ）",
        0x04 => "音声、2/1モード",
        0x05 => "音声、3/0モード",
        0x06 => "音声、2/2モード",
        0x07 => "音声、3/1モード",
        0x08 => "音声、3/2モード",
        0x09 => "音声、3/2＋LFEモード（3/2.1モード*1）",
        0x0A => "音声、3/3.1モード*1",
        0x0B => "音声、2/0/0-2/0/2-0.1モード*1",
        0x0C => "音声、5/2.1モード*1",
        0x0D => "音声、3/2/2.1モード*1",
        0x0E => "音声、2/0/0-3/0/2-0.1モード*1",
        0x0F => "音声、0/2/0-3/0/2-0.1モード*1",
        0x10 => "音声、2/0/0-3/2/3-0.2モード*1",
        0x11 => "音声、3/3/3-5/2/3-3/0/0.2モード*1",
        0x40 => "視覚障害者用音声解説",
        0x41 => "聴覚障害者用音声",
      },
      0x05 => {
        0x01 => "H.264|MPEG-4 AVC、映像480i(525i)、アスペクト比4:3",
        0x02 => "H.264|MPEG-4 AVC、映像480i(525i)、アスペクト比16:9 パンベクトルあり",
        0x03 => "H.264|MPEG-4 AVC、映像480i(525i)、アスペクト比16:9 パンベクトルなし",
        0x04 => "H.264|MPEG-4 AVC、映像480i(525i)、アスペクト比 > 16:9",
        0x91 => "H.264|MPEG-4 AVC、映像2160p、アスペクト比4:3",
        0x92 => "H.264|MPEG-4 AVC、映像2160p、アスペクト比16:9 パンベクトルあり",
        0x93 => "H.264|MPEG-4 AVC、映像2160p、アスペクト比16:9 パンベクトルなし",
        0x94 => "H.264|MPEG-4 AVC、映像2160p、アスペクト比 > 16:9",
        0xA1 => "H.264|MPEG-4 AVC、映像480p(525p)、アスペクト比4:3",
        0xA2 => "H.264|MPEG-4 AVC、映像480p(525p)、アスペクト比16:9 パンベクトルあり",
        0xA3 => "H.264|MPEG-4 AVC、映像480p(525p)、アスペクト比16:9 パンベクトルなし",
        0xA4 => "H.264|MPEG-4 AVC、映像480p(525p)、アスペクト比 > 16:9",
        0xB1 => "H.264|MPEG-4 AVC、映像1080i(1125i)、アスペクト比4:3",
        0xB2 => "H.264|MPEG-4 AVC、映像1080i(1125i)、アスペクト比16:9 パンベクトルあり",
        0xB3 => "H.264|MPEG-4 AVC、映像1080i(1125i)、アスペクト比16:9 パンベクトルなし",
        0xB4 => "H.264|MPEG-4 AVC、映像1080i(1125i)、アスペクト比 > 16:9",
        0xC1 => "H.264|MPEG-4 AVC、映像720p(750p)、アスペクト比4:3",
        0xC2 => "H.264|MPEG-4 AVC、映像720p(750p)、アスペクト比16:9 パンベクトルあり",
        0xC3 => "H.264|MPEG-4 AVC、映像720p(750p)、アスペクト比16:9 パンベクトルなし",
        0xC4 => "H.264|MPEG-4 AVC、映像720p(750p)、アスペクト比 > 16:9",
        0xD1 => "H.264|MPEG-4 AVC、映像240p アスペクト比4:3",
        0xD2 => "H.264|MPEG-4 AVC、映像240p アスペクト比16:9 パンベクトルあり",
        0xD3 => "H.264|MPEG-4 AVC、映像240p アスペクト比16:9 パンベクトルなし",
        0xD4 => "H.264|MPEG-4 AVC、映像240p アスペクト比 > 16:9",
        0xE1 => "H.264|MPEG-4 AVC、映像1080p(1125p)、アスペクト比4:3",
        0xE2 => "H.264|MPEG-4 AVC、映像1080p(1125p)、アスペクト比16:9 パンベクトルあり",
        0xE3 => "H.264|MPEG-4 AVC、映像1080p(1125p)、アスペクト比16:9 パンベクトルなし",
        0xE4 => "H.264|MPEG-4 AVC、映像1080p(1125p)、アスペクト比 > 16:9",
        0xF1 => "H.264|MPEG-4 AVC、映像180p アスペクト比4:3",
        0xF2 => "H.264|MPEG-4 AVC、映像180p アスペクト比16:9 パンベクトルあり",
        0xF3 => "H.264|MPEG-4 AVC、映像180p アスペクト比16:9 パンベクトルなし",
        0xF4 => "H.264|MPEG-4 AVC、映像180p アスペクト比 > 16:9",
      }
    }
    ComponentMapping.default = {}

    def component
      ComponentMapping[stream_content.to_i][component_type.to_i].to_s
    end

    def content_description
      component
    end
  end

  # 6.2.4 コンテント記述子 (Content descriptor)
  class ContentDescriptor < BinaryParser::TemplateBase
    class ContentNibble < BinaryParser::TemplateBase
      Def do
        data :content_nibble_level_1, UInt, 4
        data :content_nibble_level_2, UInt, 4
        data :user_nibble1,           UInt, 4  
        data :user_nibble2,           UInt, 4  
      end

      def genre1
        Appendix::ContentNibbleMapping[content_nibble_level_1.to_i].first
      end

      def genre2
        Appendix::ContentNibbleMapping[content_nibble_level_1.to_i][1][content_nibble_level_2.to_i].to_s
      end

      def content_description
        "#{genre1} - #{genre2}"
      end
    end

    Def do
      data :descriptor_tag,           UInt, 8
      data :descriptor_length,        UInt, 8
      SPEND var(:descriptor_length) * 8, :contents, ContentNibble
    end
  end

  # 6.2.5 国別受信可否記述子 (Country availability descriptor)
  class CountryAvailabilityDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,            UInt, 8
      data :descriptor_length,         UInt, 8
      data :country_availability_flag, UInt, 1
      data :reserved_future_use,       UInt, 7
      SPEND var(:descriptor_length) * 8 - 8, :country_codes, CountryCode
    end
  end

  # 6.2.6 衛星分配システム記述子 (Satellite delivery system descriptor)
  class SatelliteDeliverySystemDescriptor < BinaryParser::TemplateBase

    # 表6－9 「偏波」による定義
    class Polarisation < BinaryParser::TemplateBase
      PolarisationMapping = {
        0b00 => "水平",
        0b01 => "垂直",
        0b10 => "左旋",
        0b11 => "右旋",
      }

      def content_description
        to_s
      end

      def to_s
        PolarisationMapping[to_i].to_s
      end
    end

    # 表6－10 「衛星の変調方式」による定義
    class Modulation < BinaryParser::TemplateBase
      ModulationMapping = {
        0b00000 => "未定義",
        0b00001 => "QPSK",
        0b01000 => "広帯域衛星デジタル放送方式（TMCC信号参照）",
        0b01001 => "2.6GHz帯衛星デジタル音声放送方式（パイロットチャンネル参照）",
        0b01010 => "高度狭帯域CSデジタル放送方式（フィジカルレイヤヘッダ及びベースバンドヘッダ参照）",
        0b01011 => "高度広帯域衛星デジタル放送方式（TMCC信号参照）",
      }

      def content_description
        to_s
      end

      def to_s
        ModulationMapping[to_i].to_s
      end
    end

    # 表6－11 「FEC（内符号）」による定義
    class FEC < BinaryParser::TemplateBase
      FECMapping = {
        0b0000 => "未定義",
        0b0001 => "符号化率1/2",
        0b0010 => "符号化率2/3",
        0b0011 => "符号化率3/4",
        0b0100 => "符号化率5/6",
        0b0101 => "符号化率7/8",
        0b1000 => "広帯域衛星デジタル放送方式(TMCC信号参照)",
        0b1001 => "2.6GHz帯衛星デジタル音声放送方式（パイロットチャンネル参照）",
        0b1010 => "高度狭帯域CSデジタル放送方式（フィジカルレイヤヘッダ参照）",
        0b1011 => "高度広帯域衛星デジタル放送方式（TMCC信号参照）",
        0b1111 => "内符号なし",
      }

      def content_description
        to_s
      end

      def to_s
        FECMapping[to_i].to_s
      end
    end

    Def do
      data :descriptor_tag,            UInt, 8
      data :descriptor_length,         UInt, 8
      data :frequency,               BCD_f5, 32
      data :orbital_position,        BCD_f1, 16
      data :west_east_flag,            UInt, 1
      data :polarisation,      Polarisation, 2
      data :modulation,          Modulation, 5
      data :symbol_rate,             BCD_f4, 28
      data :fec_inner,                  FEC, 4
    end
  end

  # 6.2.7 拡張形式イベント記述子 (Extended event descriptor)
  class ExtendedEventDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,                          UInt, 8
      data :descriptor_length,                       UInt, 8
      data :descriptor_number,                       UInt, 4
      data :last_descriptor_number,                  UInt, 4
      data :iso_639_language_code,           LanguageCode, 24
      data :length_of_items,                         UInt, 8
      SPEND var(:length_of_items) * 8, :items do
        data :item_description_length,               UInt, 8
        data :item_description_char, Appendix::ARIBString, var(:item_description_length) * 8
        data :item_length,                           UInt, 8
        data :item_char,             Appendix::ARIBString, var(:item_length) * 8
      end
      data :text_length,                             UInt, 8
      data :text_char,               Appendix::ARIBString, var(:text_length) * 8
    end
  end

  # 6.2.8 リンク記述子 (Linkage descriptor)


  # 6.2.9 モザイク記述子 (Mosaic descriptor)


  # 6.2.10 NVOD 基準サービス記述子 (Near Video On Demand reference descriptor)


  # 6.2.11 ネットワーク名記述子 (Network name descriptor)


  # 6.2.12 パレンタルレート記述子 (Parental rating descriptor)


  # 6.2.13 サービス記述子 (Service descriptor)
  # ※ service［編成チャンネル］：放送事業者が編成する、スケジュールの一環として放送可能な番組の連続。


  # 6.2.14 サービスリスト記述子 (Service list descriptor)


  # 6.2.15 短形式イベント記述子 (Short event descriptor)
  # ※ event［番組］：同一のサービスに属している開始及び終了時刻が定められた放送データス
  #    トリーム構成要素の集合体で、ニュース、ドラマなど一つの番組を指す。また、運用上の
  #    必要に応じ、一番組中の一コーナーを指すこともできる。
  class ShortEventDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,                        UInt, 8
      data :descriptor_length,                     UInt, 8
      data :iso_639_language_code,         LanguageCode, 24
      data :event_name_length,                     UInt, 8
      data :event_name,            Appendix::ARIBString, var(:event_name_length) * 8
      data :text_length,                           UInt, 8
      data :text,                  Appendix::ARIBString, var(:text_length) * 8
    end
  end

  # 6.2.16 ストリーム識別記述子 (Stream identifier descriptor)
  class StreamIdentifierDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,                        UInt, 8
      data :descriptor_length,                     UInt, 8
      data :component_tag,                         UInt, 8  
    end
  end

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

    # ARIB STD-B10 第1部 表5-3 「記述子タグ値の割当」による定義
    DescriptorMapping = {
      0x46 => BouquetNameDescriptor,
      0x49 => CountryAvailabilityDescriptor,
      0x4d => ShortEventDescriptor,
      0x4e => ExtendedEventDescriptor,
      0x50 => ComponentDescriptor,
      0x53 => CAIdentifierDescriptor,
      0x54 => ContentDescriptor,
    }
    DescriptorMapping.default = UndefinedDescriptor
    
    def self.new(binary, parent_scope=nil)
      descriptor_tag = binary.sub(:byte_length => 1).to_i
      return DescriptorMapping[descriptor_tag].new(binary)
    end
  end        
end

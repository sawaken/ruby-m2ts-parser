# -*- coding: utf-8 -*-
module M2TSParser
  class Descriptor < BinaryParser::TemplateBase

    class CountryCode < Binary
      Def do
        data :code, Binary, 24
      end

      def to_s
        code.to_s
      end
    end

    String = Binary
    AribString = Binary

    Def do
      data :descriptor_tag,             UInt, 8
      data :descriptor_length,          UInt, 8

      # 6.2.1 ブーケ名記述子 (Bouquet name descriptor)
      IF E{ descriptor_tag == 0x0 } do
        data :chars,                    Binary, var(:descriptor_length) * 8
      end

      # 6.2.2 CA 識別記述子 (CA identifier descriptor)
      IF E{ descriptor_tag == 0x0 } do
        SPEND var(:descriptor_length) * 8, :ca_system_ids, UInt16
      end

      # 6.2.3  コンポーネント記述子 (Component descriptor)
      IF E{ descriptor_tag == 0x50 } do
        data :reserved_future_use1,     UInt,   4
        data :stream_content,           UInt,   4
        data :component_type,           UInt,   8
        data :component_tag,            UInt,   8
        data :iso_639_language_code,    Binary, 24
        data :text,                     AribString, var(:descriptor_length) * 8 - 48
      end

      # 6.2.4 コンテント記述子 (Content descriptor)
      IF E{ descriptor_tag == 0x0 } do
        SPEND var(:descriptor_length) * 8, :contents do
          data :content_nibble_level_1, UInt, 4
          data :content_nibble_level_2, UInt, 4
          data :user_nibble1,           UInt, 4  
          data :user_nibble2,           UInt, 4  
        end
      end

      # 6.2.5 国別受信可否記述子 (Country availability descriptor)
      IF E{ descriptor_tag == 0x0 } do
        data :country_availability_flag, UInt, 1
        data :reserved_future_use2,      UInt, 1
        SPEND var(:descriptor_length) * 8, :country_codes, CountryCode
      end

      # 6.2.6 衛星分配システム記述子 (Satellite delivery system descriptor)
      IF E{ descriptor_tag == 0x0 } do


      end

      # 6.2.7 拡張形式イベント記述子 (Extended event descriptor)
      IF E{ descriptor_tag == 0x0 } do

      end

      # 6.2.8 リンク記述子 (Linkage descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.9 モザイク記述子 (Mosaic descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.10 NVOD 基準サービス記述子 (Near Video On Demand reference descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.11 ネットワーク名記述子 (Network name descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.12 パレンタルレート記述子 (Parental rating descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.13 サービス記述子 (Service descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.14 サービスリスト記述子 (Service list descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.15 短形式イベント記述子 (Short event descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.16 ストリーム識別記述子 (Stream identifier descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.17 スタッフ記述子 (Stuffing descriptor)
      IF E { descriptor_tag == 0x0 } do

      end

      # 6.2.18 タイムシフトイベント記述子 (Time shifted event descriptor)

      # 6.2.53 データブロードキャスト識別記述子 (data broadcast id descriptor)
    
    end
  end
end

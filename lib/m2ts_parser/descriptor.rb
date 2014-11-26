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

  # ARIB-STD-B10 第2部 (v4_9), 付録M 「限定受信方式識別の割当状況」に従う定義
  class CASystemId < BinaryParser::TemplateBase
    Def do
      data :ca_system_id, UInt, 16
    end

    # 限定受信方式識別の割当状況
    ASSIGNMENT = {
      0x0001 => ["スカパー限定受信方式",       "スカパーJSAT独自規定"],
      0x0003 => ["日立方式",                   "JCL SPEC-005*1"],
      0x0004 => ["Secure Navi方式",            "JCL SPEC-005*1"],
      0x0005 => ["ARIB限定受信方式",           "ARIB TR-B14, B15"],
      0x0006 => ["松下CATV限定受信方式",       "JCL SPEC-005*1"],
      0x0007 => ["ケーブルラボ視聴制御方式",   "JCL SPEC-001-01*1, JCL SPEC-002*1, JCL SPEC-007*1"],
      0x0008 => ["u-CAS方式",                  ""],
      0x0009 => ["PowerKEY方式",               ""],
      0x000A => ["ARIB限定受信B方式",          "ARIB TR-B26"],
      0x000B => ["パイシス限定受信方式",       ""],
      0x000C => ["MULTI2-NAGRA方式",           ""],
      0x000D => ["IPTVフォーラム・Marlin方式", "IPTV規定 IP放送仕様"]
    }

    def to_s
      ASSIGNMENT[ca_system_id.to_i].to_s
    end

    def content_description
      to_s
    end
  end

  # ARIB-STD-B10 第2部 (v4_9), 付録H 「コンテント記述子におけるジャンル指定」に従う定義
  ContentNibbleMapping = {
    0x0 => ["ニュース／報道", {
              0x0 => "定時・総合",
              0x1 => "天気",
              0x2 => "特集・ドキュメント",
              0x3 => "政治・国会",
              0x4 => "経済・市況",
              0x5 => "海外・国際",
              0x6 => "解説",
              0x7 => "討論・会談",
              0x8 => "報道特番",
              0x9 => "ローカル・地域",
              0xA => "交通",
              0xF => "その他",
            }],

    0x1 => ["スポーツ", {
              0x0 => "スポーツニュース",
              0x1 => "野球",
              0x2 => "サッカー",
              0x3 => "ゴルフ",
              0x4 => "その他の球技",
              0x5 => "相撲・格闘技",
              0x6 => "オリンピック・国際大会",
              0x7 => "マラソン・陸上・水泳",
              0x8 => "モータースポーツ",
              0x9 => "マリン・ウィンタースポーツ",
              0xA => "競馬・公営競技",
              0xF => "その他",
            }],

    0x2 => ["情報／ワイドショー", {
              0x0 => "芸能・ワイドショー",
              0x1 => "ファッション",
              0x2 => "暮らし・住まい",
              0x3 => "健康・医療",
              0x4 => "ショッピング・通販",
              0x5 => "グルメ・料理",
              0x6 => "イベント",
              0x7 => "番組紹介・お知らせ",
              0xF => "その他",
            }],

    0x3 => ["ドラマ", {
              0x0 => "国内ドラマ",
              0x1 => "海外ドラマ",
              0x2 => "時代劇",
              0xF => "その他",
            }],

    0x4 => ["音楽", {
              0x0 => "国内ロック・ポップス",
              0x1 => "海外ロック・ポップス",
              0x2 => "クラシック・オペラ",
              0x3 => "ジャズ・フュージョン",
              0x4 => "歌謡曲・演歌",
              0x5 => "ライブ・コンサート",
              0x6 => "ランキング・リクエスト",
              0x7 => "カラオケ・のど自慢",
              0x8 => "民謡・邦楽",
              0x9 => "童謡・キッズ",
              0xA => "民族音楽・ワールドミュージック",
              0xF => "その他",
            }],

    0x5 => ["バラエティ", {
              0x1 => "ゲーム",
              0x2 => "トークバラエティ",
              0x3 => "お笑い・コメディ",
              0x4 => "音楽バラエティ",
              0x5 => "旅バラエティ",
              0x6 => "料理バラエティ",
              0xF => "その他",
            }],

    0x6 => ["映画", {
              0x0 => "洋画",
              0x1 => "邦画",
              0x2 => "アニメ",
              0xF => "その他",
            }],

    0x7 => ["アニメ／特撮", {
              0x0 => "国内アニメ",
              0x1 => "海外アニメ",
              0x2 => "特撮",
              0xF => "その他",
            }],

    0x8 => ["ドキュメンタリー／教養", {
              0x0 => "社会・時事",
              0x1 => "歴史・紀行",
              0x2 => "自然・動物・環境",
              0x3 => "宇宙・科学・医学",
              0x4 => "カルチャー・伝統文化",
              0x5 => "文学・文芸",
              0x6 => "スポーツ",
              0x7 => "ドキュメンタリー全般",
              0x8 => "インタビュー・討論",
              0xF => "その他",
            }],

    0x9 => ["劇場／公演", {
              0x0 => "現代劇・新劇",
              0x1 => "ミュージカル",
              0x2 => "ダンス・バレエ",
              0x3 => "落語・演芸",
              0x4 => "歌舞伎・古典",
              0xF => "その他",
            }],

    0xA => ["趣味／教育", {
              0x0 => "旅・釣り・アウトドア",
              0x1 => "園芸・ペット・手芸",
              0x2 => "音楽・美術・工芸",
              0x3 => "囲碁・将棋",
              0x4 => "麻雀・パチンコ",
              0x5 => "車・オートバイ",
              0x6 => "コンピュータ・ＴＶゲーム",
              0x7 => "会話・語学",
              0x8 => "幼児・小学生",
              0x9 => "中学生・高校生",
              0xA => "大学生・受験",
              0xB => "生涯教育・資格",
              0xC => "教育問題",
              0xF => "その他",
            }],

    0xB => ["福祉", {
              0x0 => "高齢者",
              0x1 => "障害者",
              0x2 => "社会福祉",
              0x3 => "ボランティア",
              0x4 => "手話",
              0x5 => "文字（字幕）",
              0x6 => "音声解説",
              0xF => "その他",
            }],

    0xE => ["拡張", {
              0x0 => "BS/地上デジタル放送用番組付属情報",
              0x1 => "広帯域CS デジタル放送用拡張",
              0x2 => "衛星デジタル音声放送用拡張",
              0x3 => "サーバー型番組付属情報",
              0x4 => "IP 放送用番組付属情報",
            }],

    0xF => ["その他", {
              0xF => "その他",
            }],
  }
  ContentNibbleMapping.default = ["", {}]


  # 6.2.1 ブーケ名記述子 (Bouquet name descriptor)
  # ※ bouquet［ブーケ］：放送事業者から1 つのものとして提供されるサービス（編成チャンネル）の集合。
  class BouquetNameDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,          UInt, 8
      data :descriptor_length,       UInt, 8
      data :chars,             ARIBString, var(:descriptor_length) * 8
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
      SPEND var(:descriptor_length) * 8, :ca_system_ids, CASystemId
    end
  end

  # 6.2.3  コンポーネント記述子 (Component descriptor)
  # ※ component（エレメンタリーストリーム）［コンポーネント］：イベントを構成する要素。
  #    例えば、映像、音声、文字、各種データなど。
  class ComponentDescriptor < BinaryParser::TemplateBase
    Def do
      data :descriptor_tag,                UInt, 8
      data :descriptor_length,             UInt, 8
      data :reserved_future_use,           UInt, 4
      data :stream_content,                UInt, 4
      data :component_type,                UInt, 8
      data :component_tag,                 UInt, 8
      data :iso_639_language_code, LanguageCode, 24
      data :text,                    ARIBString, var(:descriptor_length) * 8 - 48
    end

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
        ContentNibbleMapping[content_nibble_level_1.to_i].first
      end

      def genre2
        ContentNibbleMapping[content_nibble_level_1.to_i][1][content_nibble_level_2.to_i].to_s
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
    class Polarisation < BinaryParser::TemplateBase

    end

    class Modulation < BinaryParser::TemplateBase

    end

    # 表6－11 FEC（内符号）による定義
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

      Def do
        data :code, UInt, 4
      end

      def content_description
        to_s
      end

      def to_s
        FECMapping[code.to_i].to_s
      end
    end

    class BCD < BinaryParser::TemplateBase
      Def do
        SPEND rest, :decimals, UInt4
      end

      def to_i
        decimals.inject(0){|acc, n| acc * 10 + n}
      end

      def content_description
        to_i.to_s
      end
    end

    Def do
      data :descriptor_tag,            UInt, 8
      data :descriptor_length,         UInt, 8
      data :frequency,                  BCD, 32
      data :orbital_position,           BCD, 16
      data :west_east_flag,            UInt, 1
      data :polarisation,      Polarisation, 2
      data :modulation,          Modulation, 5
      data :symbol_rate,                BCD, 28
      data :fec_inner,                  FEC, 4
    end
  end

  # 6.2.7 拡張形式イベント記述子 (Extended event descriptor)


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
      data :descriptor_tag,                UInt, 8
      data :descriptor_length,             UInt, 8
      data :iso_639_language_code, LanguageCode, 24
      data :event_name_length,             UInt, 8
      data :event_name,              ARIBString, var(:event_name_length) * 8
      data :text_length,                   UInt, 8
      data :text,                    ARIBString, var(:text_length) * 8
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

    # ARIB STD-B10 第1部 表5-3 「記述子タグ値の割当」による定義
    DescriptorMapping = {
      0x46 => BouquetNameDescriptor,
      0x49 => CountryAvailabilityDescriptor,
      0x4d => ShortEventDescriptor,
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

# -*- coding: utf-8 -*-

# ARIB-STD-B10 第2部 (v4_9), 5.2項に従うテーブルの定義

module M2TSParser
  class Table < BinaryParser::TemplateBase
    include Appendix::CRC32Decoder
  end

  # 5.2.1 プログラムアソシエーションテーブル (PAT) (Program Association Table)
  # * ISO/IEC 13818-1(22), 2.4.4項

  # 5.2.2 限定受信テーブル (CAT) (Conditional Access Table)
  # * ISO/IEC 13818-1(22), 2.4.4項

  # 5.2.3 プログラムマップテーブル (PMT) (Program Map)
  # * ISO/IEC 13818-1(22), 2.4.4項

  # 5.2.4 ネットワーク情報テーブル (NIT) (Network Information Table)

  # 5.2.5 ブーケアソシエーションテーブル (BAT) (Bouquet Association Table)
  class BouquetAssociationSection < Table
    Def do
      data :table_id,                       UInt, 8
      data :section_syntax_indicator,       UInt, 1
      data :reserved_future_use1,           UInt, 1
      data :reserved1,                      UInt, 2
      data :section_length,                 UInt, 12
      data :bouquet_id,                     UInt, 16
      data :reserved2,                      UInt, 2
      data :version_number,                 UInt, 5
      data :current_next_indicator,         UInt, 1
      data :section_number,                 UInt, 8
      data :last_section_number,            UInt, 8
      data :reserved_future_use2,           UInt, 4
      data :bouquet_descriptors_length,     UInt, 12

      SPEND var(:bouquet_descriptors_length) * 8, :descriptors, Descriptor

      data :reserved_future_user3,          UInt, 4
      data :transport_stream_loop_length,   UInt, 12
      
      SPEND var(:transport_stream_loop_length) * 8, :transport_stream_loop do
        data :transport_stream_id,          UInt, 16
        data :original_network_id,          UInt, 16
        data :reserved_future_use4,         UInt, 4
        data :transport_descriptors_length, UInt, 12
        SPEND var(:transport_descriptors_length) * 8, :descriptors, Descriptor
      end
      
      data :crc_32,                         UInt, 32
    end
  end

  # 5.2.6 サービス記述テーブル (SDT) (Service Description Table)

  # 5.2.7 イベント情報テーブル (EIT) (Event Information Table)
  class EventInformationSection < Table
    Def do
      data :table_id,                    UInt, 8
      data :section_syntax_indicator,    UInt, 1
      data :reserved_future_use,         UInt, 1
      data :reserved1,                   UInt, 2
      data :section_length,              UInt, 12
      data :service_id,                  UInt, 16
      data :reserved2,                   UInt, 2
      data :version_number,              UInt, 5
      data :current_next_indicator,      UInt, 1
      data :section_number,              UInt, 8
      data :last_section_number,         UInt, 8
      data :transport_stream_id,         UInt, 16
      data :original_network_id,         UInt, 16
      data :segment_last_section_number, UInt, 8
      data :last_table_id,               UInt, 8

      SPEND var(:section_length) * 8 - 88 - 32, :events do 
        data :event_id,                             UInt, 16
        data :start_time,             Appendix::AribTime, 40
        data :duration,           Appendix::AribDuration, 24
        data :running_status,                       UInt, 3
        data :free_ca_mode,                         UInt, 1
        data :descriptors_loop_length,              UInt, 12
        SPEND var(:descriptors_loop_length) * 8, :descriptors, Descriptor
      end

      data :crc_32,                      UInt, 32
    end
  end

  # 未定義テーブル
  class UndefinedSection < Table
    Def do
      data :table_id,                    UInt, 8
      data :section_syntax_indicator,    UInt, 1
      data :reserved_future_use,         UInt, 1
      data :reserved1,                   UInt, 2
      data :section_length,              UInt, 12
      data :rest,                        UInt, rest
    end
  end

  class TableSelector < BinaryParser::TemplateBase
    class AbstractSection < BinaryParser::TemplateBase
      # ARIB STD-B10 第2部 表5－2 「テーブルID の割当および送出の基準」による定義
      def self.TableMapping(table_id)
        case table_id
        when 0x4e, 0x4f, 0x50..0x5f, 0x60..0x6f
          EventInformationSection
        else
          UndefinedSection
        end
      end

      def self.new(binary, parent_scope=nil)
        table_id = binary.sub(:byte_length => 1).to_i
        return TableMapping(table_id).new(binary)
      end
    end

    # ISO13818-1 Table 2-24 – Program specific information pointer
    #   > The beginning of a section is indicated by a pointer_field in the Transport Stream
    #   > packet payload. The syntax of this field is specified in Table 2-24.
    #   * from page 41
    Def do
      data :pointer_field,            UInt, 8
      data :padding,                  UInt, var(:pointer_field) * 8
      data :section,       AbstractSection, rest
    end
  end 
end


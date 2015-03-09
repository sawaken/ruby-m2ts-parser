class ProgramAssociationSection < BinaryParser::TemplateBase
  Def do
    data :table_id                , UInt, 8
    data :section_syntax_indicator, UInt, 1
    data :const0                  , UInt, 1
    data :reserved                , UInt, 2
    data :section_length          , UInt, 12
    data :transport_stream_id     , UInt, 16
    data :reserved                , UInt, 2
    data :version_number          , UInt, 5
    data :current_next_indicator  , UInt, 1
    data :section_number          , UInt, 8
    data :last_section_number     , UInt, 8
    SPEND var(:v) * 8, :v do
      data :program_number        , UInt, 16
      data :reserved              , UInt, 3
      IF E{program_number == 0b0} do
        data :network_PID         , UInt, 13
      end
      IF E{ else } do
        data :program_map_PID     , UInt, 13
      end
    end
    data :CRC_32                  , UInt, 32
  end
end

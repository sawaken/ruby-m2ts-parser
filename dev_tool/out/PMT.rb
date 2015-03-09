class TSProgramMapSection < BinaryParser::TemplateBase
  Def do
    data :table_id                , UInt, 8
    data :section_syntax_indicator, UInt, 1
    data :zero                    , UInt, 1
    data :reserved                , UInt, 2
    data :section_length          , UInt, 12
    data :program_number          , UInt, 16
    data :reserved                , UInt, 2
    data :version_number          , UInt, 5
    data :current_next_indicator  , UInt, 1
    data :section_number          , UInt, 8
    data :last_section_number     , UInt, 8
    data :reserved                , UInt, 3
    data :PCR_PID                 , UInt, 13
    data :reserved                , UInt, 4
    data :program_info_length     , UInt, 12
    SPEND var(:v) * 8, :v do
      descriptor()
    end
    SPEND var(:v) * 8, :v do
      data :stream_type           , UInt, 8
      data :reserved              , UInt, 3
      data :elementary_PID        , UInt, 13
      data :reserved              , UInt, 4
      data :ES_info_length        , UInt, 12
      SPEND var(:v) * 8, :v do
        descriptor()
      end
    end
    data :CRC_32                  , UInt, 32
  end
end

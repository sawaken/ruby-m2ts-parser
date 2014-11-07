# 2.4.3.1 Transport Stream                 (Table 2-1)
# 2.4.3.2 Transport Stream packet layer    (Table 2-2)
# 2.4.3.4 Adaptation field                 (Table 2-6)

module M2TSParser
  class MPEGTransportStream < BinaryParser::StreamTemplateBase

    Def(188) do
      data :sync_byte,                                        UInt, 8
      data :transport_error_indicator,                        UInt, 1
      data :payload_unit_start_indicator,                     UInt, 1
      data :transport_priority,                               UInt, 1
      data :pid,                                              UInt, 13
      data :transport_scrambling_control,                     UInt, 2
      data :adaptation_field_control,                         UInt, 2
      data :continuity_counter,                               UInt, 4

      IF E{ adaptation_field_control == 0b10 || adaptation_field_control == 0b11 } do
        data :adaptation_field_length,                        UInt, 8

        IF E{ adaptation_field_length > 0 } do
          data :discontinuity_indicator,                      UInt, 1
          data :random_access_indicator,                      UInt, 1
          data :elementary_stream_priority_indicator,         UInt, 1
          data :pcr_flag,                                     UInt, 1
          data :opcr_flag,                                    UInt, 1
          data :splicing_point_flag,                          UInt, 1
          data :transport_private_dataa_flag,                 UInt, 1
          data :adaptation_field_extension_flag,              UInt, 1
          
          IF E{ pcr_flag == 1 } do
            data :program_clock_reference_base,               UInt, 33
            data :reserved1,                                  UInt, 6
            data :program_clock_reference_extension,          UInt, 9
          end

          IF E{ opcr_flag == 1 } do
            data :original_program_clock_reference_base,      UInt, 33
            data :reserved2,                                  UInt, 6
            data :original_program_clock_reference_extension, UInt, 9
          end

          IF E{ splicing_point_flag == 1 } do
            data :splice_countdown,                           UInt, 8
          end

          IF E{ transport_private_data_flag == 1 } do
            data :transport_private_data_length,              UInt, 8
            data :private_data_bytes, Binary, var(:transport_private_data_length) * 8
          end

          IF E{ adaptation_field_extension_flag == 1 } do
            data :adaptation_field_extension_length,          UInt, 8
            data :ltw_flag,                                   UInt, 1
            data :piecewise_rate_flag,                        UInt, 1
            data :seamless_splice_flag,                       UInt, 1
            data :reserved3,                                  UInt, 5

            IF E{ ltw_flag == 1 } do
              data :ltw_valid_flag,                           UInt, 1
              data :ltw_offset,                               UInt, 15
            end

            IF E{ piecewise_rate_flag == 1 } do
              data :reserved4,                                UInt, 2
              data :piecewise_rate,                           UInt, 22
            end

            IF E{ seamless_splice_flag == 1 } do
              data :splice_type,                              UInt, 4
              data :dts_next_au_32_30,                        UInt, 3
              data :marker_bit1,                              UInt, 1
              data :dts_next_au_29_15,                        UInt, 15
              data :marker_bit2,                              UInt, 1
              data :dts_next_au_14_0 ,                        UInt, 15
              data :marker_bit3,                              UInt, 1
            end

            data :reserved5, Binary, var(:adaptation_field_extension_length) * 8 - position
          end

          data :stuffing_bytes, Binary, var(:adaptation_field_length) * 8 - position
        end
      end

      IF E{ adaptation_field_control == 0b01 || adaptation_field_control == 0b11 } do
        data :data_bytes,                                     Binary, rest
      end
    end

    def rest?
      non_proceed_get_next && non_proceed_get_next.sync_byte == 0x47
    end
  end
end

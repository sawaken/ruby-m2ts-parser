require "binary_parser"
require "./mpeg_transport_stream.rb"

require "./descriptor.rb"
require "./table.rb"


module M2TSParser

  File.open('16ch20sec.ts', 'rb') do |f|
    stream = MPEGTransportStream.new(f).filter{|packet| packet.pid == 0x12}
    while stream.rest?
      packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
      valid = packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }

      if valid
        data = packets.map{|p| p.data_bytes.to_s}.inject{|acc, p| acc + p}
        if data && data.length > 0
          eit = EventInformationSection.new(data)
          
          puts "#{packets.size} packets (#{valid}), table_id=#{eit.table_id}, CNI=#{eit.current_next_indicator.to_i}, SEC_NUM=#{eit.section_number}, Last_SEC_NUM=#{eit.last_section_number}, real=#{eit.binary_bit_length/8}byte, require=#{eit.structure_bit_length/8}byte, enough=#{eit.hold_enough_binary?}."
        end
      end

      #packet.show(true)
      #puts "sync_byte: #{packet.sync_byte}, cc: #{packet.continuity_counter}, af_len: #{packet.adaptation_field_length}"
    end
  end
end
  

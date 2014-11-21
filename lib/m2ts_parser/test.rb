require "../../../ruby-binary-parser/lib/binary_parser.rb"
require "tsparser"
require "./mpeg_transport_stream.rb"


require "./descriptor.rb"
require "./table.rb"
require "./crc32.rb"


module M2TSParser

  EventInformationSection.include(CRC32Decoder)

  class PF < BinaryParser::TemplateBase
    Def do
      data :pointer_field, UInt,                    8
      data :eit,           EventInformationSection, rest
    end
  end
      

  File.open('16ch20sec.ts', 'rb') do |f|
    stream = MPEGTransportStream.new(f).filter{|packet| packet.pid == 0x12}
    while stream.rest?
      packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
      valid = packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }

      if valid
        data = packets.map{|p| p.data_bytes.to_s}.inject{|acc, p| acc + p}
        if data && data.length > 0
          eit = PF.new(data).eit
          eit.show(true)
          p eit.check_crc32
        end
      end
    end
  end
end

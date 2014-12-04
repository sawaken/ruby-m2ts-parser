# -*- coding: utf-8 -*-
require '../m2ts_parser.rb'

module M2TSParser
  File.open('16ch20sec.ts', 'rb') do |f|
    stream = MPEGTransportStream.new(f).filter{|packet| packet.pid == 0x12}
    while stream.rest?
      packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
      valid = packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }

      if valid
        data = packets.map{|p| p.data_bytes.to_s}.inject{|acc, p| acc + p}
        if data && data.length > 0
          eit = TableSelector.new(data).section
          eit.show(true)
          p eit.check_crc32
        end
      end
    end
  end
end

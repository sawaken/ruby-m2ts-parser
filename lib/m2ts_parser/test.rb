require "mpeg_transport_stream.ts"

File.open('16ch20sec.ts', 'rb') do |f|
  stream = M2TSParser::MPEGTransportStream.new(f)#.filter{|packet| packet.pid == 0x12}
  while stream.rest?
    packet = stream.get_next
    puts "sync_byte: #{packet.sync_byte}, cc: #{packet.continuity_counter}, af_len: #{packet.adaptation_field_length}"
  end
end

# -*- coding: utf-8 -*-

module M2TSParser
  module Application
    module PATParse
      extend self

      def parse(path)
        pat = pat_parse(path)
        pat.map{|sid, pid| [sid, pmt_parse(path, pid)]}.to_h
      end

      def pat_parse(path)
        pat = {}
        File.open(path, 'rb') do |f|
          stream = MPEGTransportStream.new(f).filter{|packet|  PIDMAP[:PAT].include?(packet.pid)}
          while stream.rest?
            packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
            if packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }
              data = packets.map{|p| p.data_bytes.to_s}.inject(&:+)
              if data && data.length > 0
                TableSelector.new(data).section.mapping.each do |ref|
                  if ref.program_map_PID
                    pat[ref.program_number.to_i] = ref.program_map_PID.to_i
                  end
                end
              end
            end
          end
        end
        return pat
      end

      def pmt_parse(path, pid)
        pids = []
        File.open(path, 'rb') do |f|
          stream = MPEGTransportStream.new(f).filter{|packet| packet.pid == pid}
          while stream.rest?
            packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
            if packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }
              data = packets.map{|p| p.data_bytes.to_s}.inject(&:+)
              if data && data.length > 0
                section = TableSelector.new(data).section
                section.show(true)
                section.streams.each do |stream|
                  pids << stream.elementary_PID.to_i
                end
              end
            end
          end
        end
        return pids.uniq
      end
    end
  end
end

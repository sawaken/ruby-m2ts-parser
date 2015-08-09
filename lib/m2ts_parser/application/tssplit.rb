# -*- coding: utf-8 -*-

module M2TSParser
  module Application
    module TSSplit
      extend self

      def split(src_path, dest_path, sid)
        pat = parse_first_pat(src_path)
        puts "pat=#{pat}"
        pmt = parse_first_pmt(src_path, pat[sid])
        puts "pmt=#{pmt}"
        needed = PIDMAP[:PAT] + pmt + [pat[sid]]
        File.open(dest_path, 'wb') do |w|
          File.open(src_path, 'rb') do |r|
            stream = MPEGTransportStream.new(r).filter{|packet|  needed.include?(packet.pid)}
            while stream.rest?      
              w << stream.get_next
            end
          end
        end
      end

      def parse_first_pat(src_path)
        res = {}
        open_pats(src_path){|pats| pats.first}.mapping.each do |ref|
          if ref.program_map_PID
            res[ref.program_number.to_i] = ref.program_map_PID.to_i
          end
        end
        return res
      end

      def parse_first_pmt(src_path, pid)
        res = []
        pmt = open_pmts(src_path, pid){|pmts| pmts.first}
        res << pmt.PCR_PID.to_i
        pmt.streams.each do |stream|
          if stream.stream_type != 0x0d
            res << stream.elementary_PID.to_i
          end
        end
        return res
      end

      def parse(path)
        pat = pat_parse(path)
        pat.map{|sid, pid| [sid, pmt_parse(path, pid)]}.to_h
      end

      def open_pats(path, &proc)
        File.open(path, 'rb') do |f|
          e = Enumerator.new do |y|
            stream = MPEGTransportStream.new(f).filter{|packet|  PIDMAP[:PAT].include?(packet.pid)}
            while stream.rest?
              packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
              if packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }
                data = packets.map{|p| p.data_bytes.to_s}.inject(&:+)
                if data && data.length > 0
                  y << TableSelector.new(data).section
                end
              end
            end
          end
          proc.call(e)
        end
      end
      
      def open_pmts(path, pid, &proc)
        File.open(path, 'rb') do |f|
          e = Enumerator.new do |y|
            stream = MPEGTransportStream.new(f).filter{|packet| packet.pid == pid}
            while stream.rest?
              packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
              if packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }
                data = packets.map{|p| p.data_bytes.to_s}.inject(&:+)
                if data && data.length > 0
                  y << TableSelector.new(data).section
                end
              end
            end
          end
          proc.call(e)
        end
      end
    end
  end
end

# -*- coding: utf-8 -*-

module M2TSParser
  module Application
    module PIDDump
      extend self

      def parse(path)
        pids = Hash.new{0}
        File.open(path, 'rb') do |f|
          stream = MPEGTransportStream.new(f)
          while stream.rest?
            packet = stream.get_next
            pids[packet.pid.to_i] += 1
          end
        end
        pids
      end
    end
  end
end

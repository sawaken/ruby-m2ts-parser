# -*- coding: utf-8 -*-

module M2TSParser
  module Application
    module EpgParse
      extend self

      def parse(path)
        parsed = []
        File.open(path, 'rb') do |f|
          stream = MPEGTransportStream.new(f).filter{|packet| packet.pid == 0x12}
          while stream.rest?
            packets = stream.get_sequence{|packet| packet.payload_unit_start_indicator == 1 }
            if packets.each_cons(2).all?{|a, b| (a.continuity_counter + 1) % 16 == b.continuity_counter }
              data = packets.map{|p| p.data_bytes.to_s}.inject(&:+)
              if data && data.length > 0
                parsed.concat eit_to_epgs(TableSelector.new(data).section)
              end
            end
          end
        end
        return parsed
      end

      def eit_to_epgs(eit)
        service_id = eit.service_id.to_i
        eit.events.map{|e| event_to_epg(service_id, e)}
      end

      def event_to_epg(service_id, event)
        {
          id:         [service_id, event.event_id.to_i],
          service_id: service_id,
          event_id:   event.event_id.to_i,
          start_time: event.start_time.to_s,
          duration:   event.duration.to_sec,
          duration_pretty:   event.duration.to_s,

          event_name: event.descriptors
            .select{|d| d.is_a? ShortEventDescriptor}
            .map{|d| d.event_name ? d.event_name.content_description : ""},

          text: event.descriptors
            .select{|d| d.is_a? ShortEventDescriptor}
            .map{|d| d.text ? d.text.content_description : ""},

          extended_text: event.descriptors
            .select{|d| d.is_a? ExtendedEventDescriptor}
            .map{|d| d.items.map{|i|
              {
                description: i.item_description_char ? i.item_description_char.content_description : "",
                text:        i.item_char ? i.item_char.content_description : ""
              }}},

          content_nibble: event.descriptors
            .select{|d| d.is_a? ContentDescriptor}
            .map{|d| d.contents.map{|c|
              {
                :level1 => {id: c.content_nibble_level_1.to_i, name: c.genre1},
                :level2 => {id: c.content_nibble_level_2.to_i, name: c.genre2},
              }}}
        }
      end
    end
  end 
end

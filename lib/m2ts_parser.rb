=begin
require 'm2ts_parser/version'
require 'm2ts_parser/mpeg_transport_stream'
require 'm2ts_parser/application/epg_parse'
require 'm2ts_parser/application/pat_parse'
=end
module M2TSParser 
  DEF_FILES =
    [
     'common.rb',
     'descriptor.rb',
     'mpeg_transport_stream.rb',
     'table.rb',
     'pid.rb',
    ]

  LIB_ROOT = File.expand_path(File.dirname(__FILE__))

  # switching for development
  if File::exist?(LIB_ROOT + '/../../ruby-binary-parser/lib/binary_parser.rb')
    require LIB_ROOT + '/../../ruby-binary-parser/lib/binary_parser.rb'
  else
    require 'binary_parser'
  end

  require LIB_ROOT + '/m2ts_parser/version'
  Dir::glob(LIB_ROOT + '/m2ts_parser/appendix/*.rb').each{|f| require f}
  DEF_FILES.each{|file_name| require LIB_ROOT + '/m2ts_parser/' + file_name}
  Dir::glob(LIB_ROOT + '/m2ts_parser/application/*.rb').each{|f| require f}
end

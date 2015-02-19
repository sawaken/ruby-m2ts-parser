# -*- coding: utf-8 -*-

# ARIB-STD-B10 第2部 (v4_9), 付録A 「文字の符号化」に従う定義
#
#   番組配列情報の中で使用できる文字および制御コードは、ARIB STD-B24「デジタル放
#   送におけるデータ符号化方式と伝送方式」に規定される以下のものを使用することとする。
#    ・ 第1編第2部第7章7.1項で規定される8単位文字符号

module M2TSParser
  module Appendix
    class ARIBString < BinaryParser::TemplateBase
      require 'tsparser'
      def content_description
        if to_s
          begin
            arib_str = TSparser::AribString.new(TSparser::Binary.new(to_s))
            return arib_str.to_utf_8
          rescue
            return "error"
          end
        else
          return ""
        end
      end
    end
  end
end

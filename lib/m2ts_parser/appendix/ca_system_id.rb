# -*- coding: utf-8 -*-

# ARIB-STD-B10 第2部 (v4_9), 付録M 「限定受信方式識別の割当状況」に従う定義

module M2TSParser
  module Appendix
    class CASystemId < BinaryParser::TemplateBase

      # 限定受信方式識別の割当状況
      ASSIGNMENT = {
        0x0001 => ["スカパー限定受信方式",       "スカパーJSAT独自規定"],
        0x0003 => ["日立方式",                   "JCL SPEC-005*1"],
        0x0004 => ["Secure Navi方式",            "JCL SPEC-005*1"],
        0x0005 => ["ARIB限定受信方式",           "ARIB TR-B14, B15"],
        0x0006 => ["松下CATV限定受信方式",       "JCL SPEC-005*1"],
        0x0007 => ["ケーブルラボ視聴制御方式",   "JCL SPEC-001-01*1, JCL SPEC-002*1, JCL SPEC-007*1"],
        0x0008 => ["u-CAS方式",                  ""],
        0x0009 => ["PowerKEY方式",               ""],
        0x000A => ["ARIB限定受信B方式",          "ARIB TR-B26"],
        0x000B => ["パイシス限定受信方式",       ""],
        0x000C => ["MULTI2-NAGRA方式",           ""],
        0x000D => ["IPTVフォーラム・Marlin方式", "IPTV規定 IP放送仕様"]
      }

      def to_s
        ASSIGNMENT[to_i].to_s
      end

      def content_description
        to_s
      end
    end
  end
end
